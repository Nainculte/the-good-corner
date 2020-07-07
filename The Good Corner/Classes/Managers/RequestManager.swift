//
//  RequestManager.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import Foundation

protocol RequestSender {
    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> ())
}

/// Simple class responsible to send requests and handle them
class RequestManager: NSObject {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

}

// MARK: - RequestSender
extension RequestManager: RequestSender {

    func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> ()) {
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.networkError(error!)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.notOverHTTP))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(httpResponse, data)))
                return
            }

            guard let actualData = data else {
                completion(.failure(.missingData))
                return
            }
            
            completion(.success(actualData))
        }.resume()
    }
}

// MARK: - URLSessionDataDelegate
extension RequestManager: URLSessionDataDelegate {

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    willCacheResponse proposedResponse: CachedURLResponse,
                    completionHandler: @escaping (CachedURLResponse?) -> Void) {

        // Avoid caching to disk when using https
        if proposedResponse.response.url?.scheme == "https" {
            let actualResponse = CachedURLResponse(response: proposedResponse.response,
                                                   data: proposedResponse.data,
                                                   userInfo: proposedResponse.userInfo,
                                                   storagePolicy: .allowedInMemoryOnly)
            completionHandler(actualResponse)
        } else {
            completionHandler(proposedResponse)
        }
    }
}

// MARK: - NetworkError
enum NetworkError: Swift.Error {
    case missingData
    case notOverHTTP
    case httpError(HTTPURLResponse, Data?)
    case networkError(Error)
}

