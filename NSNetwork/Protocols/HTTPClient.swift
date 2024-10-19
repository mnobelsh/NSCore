//
//  HTTPClient.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// A protocol that defines an HTTP client capable of performing `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` requests.
///
/// The `HTTPClient` protocol abstracts HTTP communication, allowing conforming types to perform network requests
/// asynchronously and handle the results using a completion handler that provides a `Result` object.
///
/// Conforming types must implement methods for all supported HTTP methods.
public protocol HTTPClient: AnyObject {
    
    /// A type alias that represents the result of an HTTP request.
    ///
    /// - success: The request was successful, and the associated value contains the data returned by the server.
    /// - failure: The request failed, and the associated value contains the error.
    typealias Result = Swift.Result<Data?, HTTPError>
    
    /// A type alias that represents HTTP headers as a dictionary of key-value pairs.
    typealias Headers = [String: Any]
    
    /// A type alias that represents query parameters as a dictionary of key-value pairs.
    typealias QueryParameters = [String: Any]
    
    
    @discardableResult
    func request(
        from url: URLConvertible,
        method: HTTPMethod,
        parameters: QueryParameters?,
        headers: Headers?,
        body: Data?,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask?
    
    @discardableResult
    func request(
        from url: URLConvertible,
        method: HTTPMethod,
        parameters: QueryParameters?,
        headers: Headers?,
        body: Data?
    ) async throws -> Data?
}


// MARK: - HTTPClient + Extensions (Use default parameters value)
public extension HTTPClient {
    
    @discardableResult
    func request(
        from url: URLConvertible,
        method: HTTPMethod,
        parameters: QueryParameters? = nil,
        headers: Headers? = nil,
        body: Data? = nil,
        completion: @escaping (HTTPClient.Result) -> Void
    ) -> HTTPClientTask? {
        return request(from: url, method: method, parameters: parameters, headers: headers, body: body, completion: completion)
    }
    
    @discardableResult
    func request(
        from url: URLConvertible,
        method: HTTPMethod,
        parameters: QueryParameters? = nil,
        headers: Headers? = nil,
        body: Data? = nil
    ) async throws -> Data? {
        return try await request(from: url, method: method, parameters: parameters, headers: headers, body: body)
    }
    
}
