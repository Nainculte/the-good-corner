//
//  Category.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation

class Category: Decodable {
    let id: Int
    let name: String

    static var unknown: Category {
        .init(id: .max, name: "Inconnue")
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        // No point in checking the name if the id is the same
        return lhs.id == rhs.id
    }
}

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        // No point in adding the name to the hash the id is supposedly unique
        hasher.combine(id)
    }
}

extension Array where Element == Category {
    func categoryWithId(_ id: Int) -> Category {
        first(where: { $0.id == id }) ?? Category.unknown
    }
}
