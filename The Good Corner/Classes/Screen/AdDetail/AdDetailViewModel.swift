//
//  AdDetailViewModel.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation

protocol AdDetailRepository {
    func fetchSmallImageForAd(_ ad: Ad, completion: @escaping (Ad) -> ())
}

class AdDetailViewModel {

    private let repository: AdDetailRepository

    let ad: Ad

    init(repository: AdDetailRepository, ad: Ad) {
        self.repository = repository
        self.ad = ad
    }

    func updateImage(completion: @escaping (Ad) -> ()) {
        repository.fetchSmallImageForAd(ad, completion: completion)
    }

}
