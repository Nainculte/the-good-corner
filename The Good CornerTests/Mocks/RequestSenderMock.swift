//
//  RequestSenderMock.swift
//  The Good CornerTests
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation
@testable import The_Good_Corner

class RequestSenderMock: RequestSender {

    private let handler: (URLRequest) -> (Result<Data, NetworkError>)

    init(handler: @escaping (URLRequest) -> (Result<Data, NetworkError>)) {
        self.handler = handler
    }

    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        completion(handler(request))
    }
}
