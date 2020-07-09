//
//  APIMock.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit
@testable import The_Good_Corner

class APIMock: API {

    let adsHandler: () -> (Result<[AdDTO], APIError>)
    let categoriesHandler: () -> (Result<[The_Good_Corner.Category], APIError>)
    let imageHandler: () -> (Result<UIImage, APIError>)

    init(adsHandler: @escaping () -> (Result<[AdDTO], APIError>),
         categoriesHandler: @escaping () -> (Result<[The_Good_Corner.Category], APIError>),
         imageHandler: @escaping () -> (Result<UIImage, APIError>)) {
        self.adsHandler = adsHandler
        self.categoriesHandler = categoriesHandler
        self.imageHandler = imageHandler
    }

    required init(requestSender: RequestSender) {
        fatalError("Use init(adsHandler: categoriesHandler: imageHandler:")
    }

    func getAds(completion: @escaping (Result<[AdDTO], APIError>) -> ()) {
        completion(adsHandler())
    }

    func getCategories(completion: @escaping (Result<[The_Good_Corner.Category], APIError>) -> ()) {
        completion(categoriesHandler())
    }

    func getImage(url: URL, completion: @escaping (Result<UIImage, APIError>) -> ()) {
        completion(imageHandler())
    }
}
