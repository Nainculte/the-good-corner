//
//  Category.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation

struct Category: Decodable {
    let id: Int
    let name: String

    static var unknown: Category {
        .init(id: .max, name: "Inconnue")
    }
}
