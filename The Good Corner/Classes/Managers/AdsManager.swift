//
//  AdsManager.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

protocol AdsRepositoryDelegate: class {

    func adsRepository(_ repository: AdsRepository, didUpdate categories: [Category])

    func adsRepository(_ repository: AdsRepository, didUpdate ads: [Ad])

    func adsRepository(_ repository: AdsRepository, failedFetching error: APIError)

}

protocol AdsRepository: class, AdsListRepository {

    var ads: [Ad] { get }

    var categories: [Category] { get }

    var delegate: AdsRepositoryDelegate? { get set }

    init(api: API)

    func fetchCategoriesAndAds()

    func fetchThumbnailImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ())

    func fetchSmallImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ())

}

class AdsManager: AdsRepository {

    private let api: API

    private(set) var ads = [Ad]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.adsRepository(self, didUpdate: self.ads)
            }
        }
    }

    private(set) var categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.adsRepository(self, didUpdate: self.categories)
            }
        }
    }

    weak var delegate: AdsRepositoryDelegate?

    required init(api: API) {
        self.api = api
    }

    func fetchCategoriesAndAds() {
        api.getCategories { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                self.fetchAds()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.adsRepository(self, failedFetching: error)
                }
            }
        }
    }

    func fetchThumbnailImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ()) {
        fetchImage(urlString: ad.imagesUrl.thumb) { (image) in
            ad.thumbImage = image
            completion(ad)
        }
    }

    func fetchSmallImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ()) {
        fetchImage(urlString: ad.imagesUrl.small) { (image) in
            ad.smallImage = image
            completion(ad)
        }
    }

    private func fetchAds() {
        api.getAds { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let dtos):
                self.ads = dtos.map { Ad(dto: $0, category: self.categories.categoryWithId($0.categoryId)) }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.adsRepository(self, failedFetching: error)
                }
            }
        }
    }

    private func fetchImage(urlString: String?, completion: @escaping (UIImage?) -> ()) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                completion(nil)
                return
        }
        api.getImage(url: url) { (result) in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(_):
                completion(nil)
            }
        }
    }

}
