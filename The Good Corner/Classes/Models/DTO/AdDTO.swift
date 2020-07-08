//
//  AdDTO.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation

struct AdDTO: Decodable {

    let id: Int
    let categoryId: Int
    let title: String
    let description: String
    let price: Float
    let imagesUrl: ImagesURL
    let creationDate: Date
    let isUrgent: Bool

    struct ImagesURL: Decodable {
        let small: String?
        let thumb: String?
    }

}
