//
//  AdsListViewModel.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

protocol AdsListRepository {

    var ads: [Ad] { get }

    var categories: [Category] { get }

    func fetchCategoriesAndAds()

    func fetchThumbnailImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ())

}

class AdsListViewModel {

    private let repository: AdsListRepository

    var ads: [Ad] = []

    var categories: [Category] { repository.categories }

    var filterCategory: Category? {
        didSet {
            guard oldValue != filterCategory else { return }

            ads = Self.updateAds(repository.ads, with: filterCategory)
            didUpdateAds?()
        }
    }

    var didUpdateAds: (() -> ())?

    var didUpdateCategories: (() -> ())?

    var errorOccured: ((APIError) -> ())?

    init(repository: AdsListRepository) {
        self.repository = repository
    }

    func updateCategoriesAndAds() {
        repository.fetchCategoriesAndAds()
    }

    func getThumbnailImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ()) {
        repository.fetchThumbnailImageForAd(ad, completion: completion)
    }

    private static func updateAds(_ ads: [Ad], with filteringCategory: Category?) -> [Ad] {
        if let category = filteringCategory {
            return ads.filter { $0.category == category }
        } else {
            return ads
        }
    }

}

extension AdsListViewModel: AdsRepositoryDelegate {
    func adsRepository(_ repository: AdsRepository, didUpdate categories: [Category]) {
        didUpdateCategories?()
    }

    func adsRepository(_ repository: AdsRepository, didUpdate ads: [Ad]) {
        self.ads = Self.updateAds(ads, with: filterCategory)
        didUpdateAds?()
    }

    func adsRepository(_ repository: AdsRepository, failedFetching error: APIError) {
        errorOccured?(error)
    }
}
