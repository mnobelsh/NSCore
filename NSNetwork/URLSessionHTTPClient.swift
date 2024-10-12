//
//  URLSessionHTTPClient.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//
import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    @discardableResult
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .GET)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error { return completion(.failure(.unknown(message: error.localizedDescription))) }
            completion(URLSessionHTTPClient.mapResult(data: data, response: response))
        }
        task.resume()
        return task
    }
    
}

extension URLSessionHTTPClient {
    
    private func buildRequest(url: URL, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    static func mapResult(data: Data?, response: URLResponse?) -> HTTPClient.Result {
        guard let response = response as? HTTPURLResponse else { return .failure(.invalidResponse) }
        let emptyData = Data()
        switch response.statusCode {
        case 400...499:
            return .failure(.client(data: data == emptyData ? nil : data, code: response.statusCode))
        case 500...599:
            return .failure(.server(data: data == emptyData ? nil : data, code: response.statusCode))
        default:
            if let data = data, data != emptyData {
                return .success(data)
            } else {
                return .failure(.invalidData)
            }
        }
    }
    
}

extension URLSessionDataTask: HTTPClientTask {
    public var id: String { UUID().uuidString }
    
    public func cancelTask() {
        self.cancel()
    }
    
    public func resumeTask() {
        self.resume()
    }
}
