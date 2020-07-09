//
//  AdsListViewModelTests.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import XCTest
@testable import The_Good_Corner

class AdsListViewModelTests: XCTestCase {

    var repo: AdsRepositoryMock!
    var viewModel: AdsListViewModel!
    var ad: Ad!
    var category: The_Good_Corner.Category!

    var updateAdsCalled = false
    var updateCategoriesCalled = false
    var errorOccuredCalled = false
    var thumbImageCalled = false

    override func setUpWithError() throws {
        category = The_Good_Corner.Category(id: 1, name: "Test")
        let dto = AdDTO(id: 1,
                        categoryId: 1,
                        title: "Test",
                        description: "",
                        price: 2,
                        imagesUrl: AdDTO.ImagesURL(small: nil, thumb: nil),
                        creationDate: Date().addingTimeInterval(-400),
                        isUrgent: true)
        ad = .init(dto: dto, category: category)


        updateAdsCalled = false
        updateCategoriesCalled = false
        errorOccuredCalled = false
        thumbImageCalled = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateCategoriesAndAdsGivesCategories() {
        // given
        setupInSuccess()
        // when
        viewModel.updateCategoriesAndAds()
        // then
        XCTAssert(updateCategoriesCalled == true)
    }

    func testUpdateCategoriesAndAdsGivesAds() {
        // given
        setupInSuccess()
        // when
        viewModel.updateCategoriesAndAds()
        // then
        XCTAssert(updateAdsCalled == true)
    }

    func testUpdateCategoriesAndAdsErrors() {
        // given
        setupInError()
        // when
        viewModel.updateCategoriesAndAds()
        // then
        XCTAssert(errorOccuredCalled == true)
    }

    func testImageFetching() {
        // given
        setupInSuccess()
        // when
        viewModel.getThumbnailImageForAd(ad, completion: { _ in })
        // then
        XCTAssert(thumbImageCalled == true)
    }

    func testAddingFilter() {
        // given
        setupInSuccess()
        // when
        viewModel.filterCategory = .unknown
        // then
        XCTAssert(viewModel.ads.isEmpty == true)
    }

    func testRemovingFilter() {
        // given
        setupInSuccess()
        viewModel.filterCategory = .unknown
        // when
        viewModel.filterCategory = nil
        // then
        XCTAssert(viewModel.ads == [ad])
    }

    func testApplyingAlreadyAppliedFilterDoesNothing() {
        // given
        setupInSuccess()
        viewModel.filterCategory = .unknown
        updateAdsCalled = false
        // when
        viewModel.filterCategory = .unknown
        // then
        XCTAssert(updateAdsCalled == false)
    }

    private func didUpdateAds() {
        updateAdsCalled = true
    }

    private func didUpdateCategories() {
        updateCategoriesCalled = true
    }

    private func errorOccured(_ error: APIError) {
        errorOccuredCalled = true
    }

    private func thumbImageHandler() {
        thumbImageCalled = true
    }

    private func setupInSuccess() {
        repo = AdsRepositoryMock(ads: [ad], categories: [category], error: nil, thumbImageHandler: thumbImageHandler, smallImageHandler: nil)

        viewModel = AdsListViewModel(repository: repo)
        postSetup()
    }

    private func setupInError() {
        repo = AdsRepositoryMock(ads: nil, categories: nil, error: .parseImage, thumbImageHandler: thumbImageHandler, smallImageHandler: nil)

        viewModel = AdsListViewModel(repository: repo)
        postSetup()
    }

    private func postSetup() {
        viewModel.didUpdateAds = didUpdateAds
        viewModel.didUpdateCategories = didUpdateCategories
        viewModel.errorOccured = errorOccured(_:)
        repo.delegate = viewModel
    }

}
