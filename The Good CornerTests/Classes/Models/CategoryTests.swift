//
//  CategoryTests.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import XCTest

@testable import The_Good_Corner

class CategoryTests: XCTestCase {

    let categories: [The_Good_Corner.Category] = [.init(id: 1, name: "test"), .init(id: 2, name: "test")]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGettingExistingCategory() {
        // given

        // when
        let category = categories.categoryWithId(1)
        // then
        XCTAssert(category == categories.first)
    }

    func testGettingMissingCategory() {
        // given

        // when
        let category = categories.categoryWithId(3)
        // then
        XCTAssert(category == .unknown)
    }

    func testHashable() {
        // given
        let category = categories.first!
        var set = Set([category])
        // when
        set.insert(category)
        // then
        XCTAssert(set.count == 1)
    }

}
