//
//  BaseKai.swift
//  Kaist
//
//  Created by Airat K on 29/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import Foundation


class BaseKaiApiService {

    let userDefaults: UserDefaults = UserDefaults.standard

    private let apiUrl: URL = URL(string: "https://kai.ru/raspisanie")!

    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()

}

extension BaseKaiApiService {

    typealias NoContentResponseHandler = (_ error: DataFetchErrorType?) -> Void
    typealias ContentResponseHandler<ContentType: Decodable> = (_ content: ContentType?, _ error: DataFetchErrorType?) -> Void

}

extension BaseKaiApiService {

    func get<ContentType: Decodable>(from url: URL, onComplete handleCompletion: @escaping ContentResponseHandler<ContentType>) {
        var request: URLRequest = URLRequest(url: url)

        request.httpMethod = "GET"

        self.request(using: request, onComplete: handleCompletion)
    }

    func post<ContentType: Decodable>(_ data: Data, to url: URL, onComplete handleCompletion: @escaping ContentResponseHandler<ContentType>) {
        var request: URLRequest = URLRequest(url: url)

        request.httpMethod = "POST"
        request.httpBody = data

        self.request(using: request, onComplete: handleCompletion)
    }

}

extension BaseKaiApiService {

    func makeUrlWithQuery(queryItems: URLQueryItem...) -> URL {
        var urlComponents: URLComponents = URLComponents(url: self.apiUrl, resolvingAgainstBaseURL: true)!

        urlComponents.queryItems = queryItems.filter { $0.value != nil } .filter { !$0.value!.isEmpty }

        return urlComponents.url!
    }

}

private extension BaseKaiApiService {

    func request<ContentType: Decodable>(using request: URLRequest, onComplete handleCompletion: @escaping ContentResponseHandler<ContentType>) {
        var request: URLRequest = request

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                DispatchQueue.main.async { handleCompletion(nil, .noServerResponse) }
                return
            }

            switch response.statusCode {
            case 200..<300:
                if let json = try? self.jsonDecoder.decode(ContentType.self, from: data) {
                    DispatchQueue.main.async { handleCompletion(json, nil) }
                } else {
                    DispatchQueue.main.async { handleCompletion(nil, .onResponseParsing) }
                }

            default:
                DispatchQueue.main.async { handleCompletion(nil, .onServerError) }
            }
        } .resume()
    }

}
