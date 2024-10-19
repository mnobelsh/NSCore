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
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - GET
    @discardableResult
    public func get(
        from url: URLConvertible,
        parameters: HTTPClient.QueryParameters? = nil,
        headers: HTTPClient.Headers? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(url: url, method: .GET, parameters: parameters, headers: headers, body: nil, completion: completion)
    }
    
    public func get(
        from url: URLConvertible,
        parameters: QueryParameters?,
        headers: Headers?
    ) async throws -> Data? {
        return try await asyncRequest(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
    }
    
    // MARK: - POST
    @discardableResult
    public func post(
        _ data: Data,
        to url: URLConvertible,
        parameters: HTTPClient.QueryParameters? = nil,
        headers: HTTPClient.Headers? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(url: url, method: .POST, parameters: parameters, headers: headers, body: data, completion: completion)
    }
    
    @discardableResult
    public func post(
        _ data: Data,
        to url: URLConvertible,
        parameters: QueryParameters?,
        headers: Headers?
    ) async throws -> Data? {
        return try await asyncRequest(url: url, method: .POST, parameters: parameters, headers: headers, body: data)
    }
    
    // MARK: - PUT
    @discardableResult
    public func put(
        _ data: Data,
        to url: URLConvertible,
        parameters: HTTPClient.QueryParameters? = nil,
        headers: HTTPClient.Headers? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(url: url, method: .PUT, parameters: parameters, headers: headers, body: data, completion: completion)
    }
    
    // MARK: - PATCH
    @discardableResult
    public func patch(
        _ data: Data,
        to url: URLConvertible,
        parameters: HTTPClient.QueryParameters? = nil,
        headers: HTTPClient.Headers? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(url: url, method: .PATCH, parameters: parameters, headers: headers, body: data, completion: completion)
    }
    
    // MARK: - DELETE
    @discardableResult
    public func delete(
        from url: URLConvertible,
        parameters: HTTPClient.QueryParameters? = nil,
        headers: HTTPClient.Headers? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(url: url, method: .DELETE, parameters: parameters, headers: headers, body: nil, completion: completion)
    }
    
}

// MARK: - URLSessionHTTPClient + Extensions (Private)
private extension URLSessionHTTPClient {
    
    func asyncRequest(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: HTTPClient.QueryParameters?,
        headers: HTTPClient.Headers?,
        body: Data?
    ) async throws -> Data? {
        guard let request = buildRequest(url: url, method: .GET, queryParams: parameters, headers: headers, body: nil) else {
            throw HTTPError.invalidURL
        }
        do {
            let response = try await session.data(for: request)
            switch URLSessionHTTPClient.mapResult(data: response.0, response: response.1, error: nil) {
            case let .success(data): return data
            case let .failure(error): throw error
            }
        } catch {
            guard let httpError = error as? HTTPError else {
                throw HTTPError.unknown(message: error.localizedDescription)
            }
            throw httpError
        }
    }
    
    func request(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: HTTPClient.QueryParameters?,
        headers: HTTPClient.Headers?,
        body: Data?,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        guard let request = buildRequest(url: url, method: method, queryParams: parameters, headers: headers, body: body) else {
            completion(.failure(.invalidURL))
            return nil
        }
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard self != nil else { return }
            completion(URLSessionHTTPClient.mapResult(
                data: data,
                response: response,
                error: error)
            )
        }
        task.resume()
        return Task(wrapped: task)
    }
    
    func buildRequest(
        url: URLConvertible,
        method: HTTPMethod,
        queryParams: QueryParameters? = nil,
        headers: [String: Any?]? = nil,
        body: Data? = nil
    ) -> URLRequest? {
        guard var url = url.asURL else { return nil }
        if let queryParams = queryParams {
            var queryItems = [URLQueryItem]()
            for (key, value) in queryParams {
                let item = URLQueryItem(name: key, value: String(describing: value))
                queryItems.append(item)
            }
            url.append(queryItems: queryItems)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        if let headers = headers, !headers.isEmpty {
            for (key, value) in headers where value != nil {
                request.setValue(String(describing: value!), forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    static func mapResult(data: Data?, response: URLResponse?, error: Error?) -> HTTPClient.Result {
        if let error = error { return .failure(.unknown(message: error.localizedDescription)) }
        guard let response = response as? HTTPURLResponse else { return .failure(HTTPError.invalidResponse) }
        let emptyData = Data()
        switch response.statusCode {
        case 400...499:
            return .failure(HTTPError.client(data: data == emptyData ? nil : data, code: response.statusCode))
        case 500...599:
            return .failure(HTTPError.server(data: data == emptyData ? nil : data, code: response.statusCode))
        default:
            return .success(data)
        }
    }
    
}
