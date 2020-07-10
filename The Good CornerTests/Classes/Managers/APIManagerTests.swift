//
//  APIManagerTests.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import XCTest

@testable import The_Good_Corner

class APIManagerTests: XCTestCase {

    var api: APIManager!

    var shouldError = false

    var result: Result<UIImage, APIError>!

    let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")!

    override func setUpWithError() throws {
        let requestSender = RequestSenderMock(handler: handleRequest(_:))
        api = APIManager(requestSender: requestSender)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThumbnailImageFetching() {
        // given
        shouldError = false
        // when
        api.getImage(url: url, completion: {
            self.result = $0
        })
        // then
        do {
            let _ = try result.get()
            XCTAssert(true)
        } catch {
            XCTAssert(false)
        }
    }

    func testThumbnailImageFetchingInError() {
        // given
        shouldError = true
        // when
        api.getImage(url: url, completion: {
            self.result = $0
        })
        // then
        do {
            let _ = try result.get()
            XCTAssert(false)
        } catch {
            XCTAssert(true)
        }
    }

    private func handleRequest(_ request: URLRequest) -> Result<Data, NetworkError> {
        if shouldError {
            return .failure(.missingData)
        }
        let imageData = UIImage(named: "warning")?.pngData()
        return .success(imageData!)
    }

}
