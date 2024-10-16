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
    typealias Headers = [String: Any?]
    
    /// A type alias that represents query parameters as a dictionary of key-value pairs.
    typealias QueryParameters = [String: Any?]
    
    // MARK: - Closure Methods
    
    /// Sends an asynchronous `GET` request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to send the request to, conforming to `URLConvertible`.
    ///   - parameters: Optional query parameters to include in the request. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to include in the request. Defaults to `nil`.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    ///
    /// Example usage:
    /// ```swift
    /// let task = client.get(from: url, parameters: nil, headers: nil) { result in
    ///     switch result {
    ///     case .success(let data):
    ///         // Handle successful response with data
    ///     case .failure(let error):
    ///         // Handle error
    ///     }
    /// }
    /// ```
    @discardableResult
    func get(from url: URLConvertible, parameters: QueryParameters?, headers: Headers?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    
    /// Sends an asynchronous `POST` request to the specified URL with the given data.
    ///
    /// - Parameters:
    ///   - data: The data to be sent in the body of the `POST` request.
    ///   - url: The URL to send the request to, conforming to `URLConvertible`.
    ///   - parameters: Optional query parameters to include in the request. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to include in the request. Defaults to `nil`.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    @discardableResult
    func post(_ data: Data, to url: URLConvertible, parameters: QueryParameters?, headers: Headers?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    
    /// Sends an asynchronous `PUT` request to the specified URL with the given data.
    ///
    /// - Parameters:
    ///   - data: The data to be sent in the body of the `PUT` request.
    ///   - url: The URL to send the request to, conforming to `URLConvertible`.
    ///   - parameters: Optional query parameters to include in the request. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to include in the request. Defaults to `nil`.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    @discardableResult
    func put(_ data: Data, to url: URLConvertible, parameters: QueryParameters?, headers: Headers?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    
    /// Sends an asynchronous `PATCH` request to the specified URL with the given data.
    ///
    /// - Parameters:
    ///   - data: The data to be sent in the body of the `PATCH` request.
    ///   - url: The URL to send the request to, conforming to `URLConvertible`.
    ///   - parameters: Optional query parameters to include in the request. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to include in the request. Defaults to `nil`.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    @discardableResult
    func patch(_ data: Data, to url: URLConvertible, parameters: QueryParameters?, headers: Headers?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    
    /// Sends an asynchronous `DELETE` request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to send the request to, conforming to `URLConvertible`.
    ///   - parameters: Optional query parameters to include in the request. Defaults to `nil`.
    ///   - headers: Optional HTTP headers to include in the request. Defaults to `nil`.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    @discardableResult
    func delete(from url: URLConvertible, parameters: QueryParameters?, headers: Headers?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    
    
    // MARK: - Async Methods
    
    func get(from url: URLConvertible, parameters: QueryParameters?, headers: Headers?) async throws -> Data?
}


// MARK: - HTTPClient + Extensions (Use default parameters value)
public extension HTTPClient {
    
    // MARK: - Closure Default Implementation
    
    @discardableResult
    func get(from url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil, completion: @escaping (Result) -> Void) -> HTTPClientTask? {
        return get(from: url, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func post(_ data: Data, to url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil, completion: @escaping (Result) -> Void) -> HTTPClientTask? {
        return post(data, to: url, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func put(_ data: Data, to url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil, completion: @escaping (Result) -> Void) -> HTTPClientTask? {
        return put(data, to: url, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func patch(_ data: Data, to url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil, completion: @escaping (Result) -> Void) -> HTTPClientTask? {
        return patch(data, to: url, parameters: parameters, headers: headers, completion: completion)
    }
    
    @discardableResult
    func delete(from url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil, completion: @escaping (Result) -> Void) -> HTTPClientTask? {
        return delete(from: url, parameters: parameters, headers: headers, completion: completion)
    }
    
    // MARK: - Async Default Implementation
    
    func get(from url: URLConvertible, parameters: QueryParameters? = nil, headers: Headers? = nil) async throws -> Data? {
        return try await get(from: url, parameters: parameters, headers: headers)
    }
    
}
