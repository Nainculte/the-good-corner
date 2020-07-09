//
//  AdsRepositoryMock.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit
@testable import The_Good_Corner

class AdsRepositoryMock: AdsRepository {
    var ads: [Ad]

    var categories: [The_Good_Corner.Category]

    var delegate: AdsRepositoryDelegate?

    private let error: APIError?

    init(ads: [Ad]?,
         categories: [The_Good_Corner.Category]?,
         error: APIError?) {
        self.ads = ads ?? []
        self.categories = categories ?? []
        self.error = error
    }

    required init(api: API) {
        fatalError("Use other initializer")
    }

    func fetchCategoriesAndAds() {
        if let error = error {
            delegate?.adsRepository(self, failedFetching: error)
        } else {
            delegate?.adsRepository(self, didUpdate: categories)
            delegate?.adsRepository(self, didUpdate: ads)
        }
    }

    func fetchThumbnailImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ()) {
        completion(ad)
    }

    func fetchSmallImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ()) {
        completion(ad)
    }


}
