//
//  AdDetailViewModelTests.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import XCTest

@testable import The_Good_Corner

class AdDetailViewModelTests: XCTestCase {

    var repo: AdsRepositoryMock!
    var ad: Ad!

    var imageHandlerCalled: Bool = false

    override func setUpWithError() throws {
        repo = AdsRepositoryMock(ads: [], categories: [], error: nil, thumbImageHandler: nil, smallImageHandler: imageHandler)

        let category = The_Good_Corner.Category(id: 1, name: "Test")
        let dto = AdDTO(id: 1,
                                 categoryId: 1,
                                 title: "Test",
                                 description: "",
                                 price: 2,
                                 imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                                 creationDate: Date().addingTimeInterval(-400),
                                 isUrgent: true)
        ad = .init(dto: dto, category: category)


        imageHandlerCalled = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateImageMakesAPICall() {
        // given
        let viewModel = AdDetailViewModel(repository: repo, ad: ad)
        // when
        viewModel.updateImage(completion: { _ in })
        // then
        XCTAssert(imageHandlerCalled == true)
    }

    private func imageHandler() {
        imageHandlerCalled = true
    }

}
