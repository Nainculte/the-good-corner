//
//  Ad.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class Ad {

    let id: Int
    let category: Category
    let title: String
    let description: String
    let price: Float
    let imagesUrl: AdDTO.ImagesURL
    let creationDate: Date
    let isUrgent: Bool

    var thumbImage: UIImage?
    var smallImage: UIImage?

    init(dto: AdDTO, category: Category) {
        self.id = dto.id
        self.category = category
        self.title = dto.title
        self.description = dto.description
        self.price = dto.price
        self.imagesUrl = dto.imagesUrl
        self.creationDate = dto.creationDate
        self.isUrgent = dto.isUrgent
    }

}

extension Ad: Equatable {
    static func == (lhs: Ad, rhs: Ad) -> Bool {
        // Ids should be enough to identify ads
        return lhs.id == rhs.id
    }
}

extension Ad: Hashable {
    func hash(into hasher: inout Hasher) {
        // Id should be enough
        hasher.combine(id)
    }
}