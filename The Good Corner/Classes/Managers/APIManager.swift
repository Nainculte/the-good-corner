//
//  APIManager.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 07/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

protocol API {
    init(requestSender: RequestSender)

    func getAds(completion: @escaping (Result<[AdDTO], APIError>) -> ())

    func getCategories(completion: @escaping (Result<[Category], APIError>) -> ())

    func getImage(url: URL, completion: @escaping (Result<UIImage, APIError>) -> ())
}

class APIManager: API {

    private let requestSender: RequestSender

    required init(requestSender: RequestSender) {
        self.requestSender = requestSender
    }

    func getAds(completion: @escaping (Result<[AdDTO], APIError>) -> ()) {
        sendAndDecode(request: Routes.ads.urlRequest, completion: completion)
    }

    func getCategories(completion: @escaping (Result<[Category], APIError>) -> ()) {
        sendAndDecode(request: Routes.categories.urlRequest, completion: completion)
    }

    func getImage(url: URL, completion: @escaping (Result<UIImage, APIError>) -> ()) {
        requestSender.sendRequest(Routes.image(url).urlRequest) { (result) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.parseImage))
                }
            case .failure(let networkError):
                completion(.failure(.networkError(networkError)))
            }
        }
    }

    private func sendAndDecode<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, APIError>) -> ()) {
        requestSender.sendRequest(request) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.decode(data: data, completion: completion)
            case .failure(let networkError):
                completion(.failure(.networkError(networkError)))
            }
        }
    }

    private func decode<T: Decodable>(data: Data, completion: @escaping (Result<T, APIError>) -> ()) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let object = try decoder.decode(T.self, from: data)
            completion(.success(object))
        } catch {
            completion(.failure(.parseError(error)))
        }
    }
}

// MARK: - Routes
extension APIManager {
    enum Routes {
        case ads
        case categories
        case image(URL)

        private var url: URL {
            switch self {
            case .ads:				return URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!
            case .categories:		return URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")!
            case .image(let url):	return url
            }
        }

        private var httpMethod: String {
            switch self {
            case .ads, .categories, .image(_):	return "GET"
            }
        }

        var urlRequest: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod
            return request
        }
    }
}

// MARK: - APIError
enum APIError: Swift.Error {
    case networkError(NetworkError)
    case parseError(Error)
    case parseImage
}
