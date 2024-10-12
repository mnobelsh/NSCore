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
    public func get(from url: HTTPURLConvertible, headers: HTTPClient.Headers? = nil, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .GET, headers: headers)
        let task = session.dataTask(with: request) { data, response, error in
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func post(_ data: Data, to url: HTTPURLConvertible, headers: HTTPClient.Headers? = nil, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .POST, headers: headers, body: data)
        let task = session.dataTask(with: request) { data, response, error in
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func put(_ data: Data, to url: HTTPURLConvertible, headers: HTTPClient.Headers? = nil, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .PUT, headers: headers, body: data)
        let task = session.dataTask(with: request) { data, response, error in
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func patch(_ data: Data, to url: HTTPURLConvertible, headers: HTTPClient.Headers? = nil, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .PATCH, headers: headers, body: data)
        let task = session.dataTask(with: request) { data, response, error in
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return task
    }
    
    @discardableResult
    public func delete(from url: HTTPURLConvertible, headers: HTTPClient.Headers? = nil, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let request = buildRequest(url: url, method: .DELETE, headers: headers)
        let task = session.dataTask(with: request) { data, response, error in
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return task
    }
    
}

// MARK: - URLSessionHTTPClient + Extensions (Private)
private extension URLSessionHTTPClient {
    
    func buildRequest(
        url: HTTPURLConvertible,
        method: HTTPMethod,
        headers: [String: Any?]? = nil,
        body: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url.value)
        request.httpMethod = method.rawValue
        request.httpBody = body
        if let headers = headers, !headers.isEmpty {
            for (key, value) in headers where value != nil {
                request.setValue(String(describing: value), forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    static func mapResult(data: Data?, response: URLResponse?, error: Error?) -> HTTPClient.Result {
        if let error = error { return .failure(.unknown(message: error.localizedDescription)) }
        guard let response = response as? HTTPURLResponse else { return .failure(.invalidResponse) }
        let emptyData = Data()
        switch response.statusCode {
        case 400...499:
            return .failure(.client(data: data == emptyData ? nil : data, code: response.statusCode))
        case 500...599:
            return .failure(.server(data: data == emptyData ? nil : data, code: response.statusCode))
        default:
            return .success(data)
        }
    }
    
}
