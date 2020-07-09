//
//  AdTests.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import XCTest
import Foundation
@testable import The_Good_Corner

class AdTests: XCTestCase {

    var category: The_Good_Corner.Category!
    var urgentOldAd: Ad!
    var urgentRecentAd: Ad!
    var oldAd: Ad!
    var recentAd: Ad!

    override func setUpWithError() throws {
        category = .init(id: 1, name: "Test")

        let urgentOld = AdDTO(id: 1,
                              categoryId: 1,
                              title: "oldUrgent",
                              description: "",
                              price: 2,
                              imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                              creationDate: Date().addingTimeInterval(-800),
                              isUrgent: true)
        urgentOldAd = .init(dto: urgentOld, category: category)

        let urgentRecent = AdDTO(id: 2,
                                 categoryId: 1,
                                 title: "recentUrgent",
                                 description: "",
                                 price: 2,
                                 imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                                 creationDate: Date().addingTimeInterval(-400),
                                 isUrgent: true)
        urgentRecentAd = .init(dto: urgentRecent, category: category)

        let old = AdDTO(id: 3,
                        categoryId: 1,
                        title: "old",
                        description: "",
                        price: 2,
                        imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                        creationDate: Date().addingTimeInterval(-600),
                        isUrgent: false)
        oldAd = .init(dto: old, category: category)

        let recent = AdDTO(id: 1,
                              categoryId: 1,
                              title: "recent",
                              description: "",
                              price: 2,
                              imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                              creationDate: Date().addingTimeInterval(-200),
                              isUrgent: false)
        recentAd = .init(dto: recent, category: category)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSortUrgent() {
        // given
        let ads: [Ad] = [urgentRecentAd, urgentOldAd]
        // when
        let sorted = ads.sorted()
        // then
        XCTAssert(sorted == [urgentOldAd, urgentRecentAd])
    }

    func testSortRegular() {
        let ads: [Ad] = [recentAd, oldAd]
        // when
        let sorted = ads.sorted()
        // then
        XCTAssert(sorted == [oldAd, recentAd])
    }

    func testSortMixed() {
        let ads: [Ad] = [recentAd, urgentRecentAd, oldAd, urgentOldAd]
        // when
        let sorted = ads.sorted()
        // then
        XCTAssert(sorted == [urgentOldAd, urgentRecentAd, oldAd, recentAd])
    }

}
