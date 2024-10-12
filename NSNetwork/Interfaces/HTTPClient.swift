//
//  HTTPClient.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// A protocol that defines an HTTP client for sending `GET` and `POST` requests.
///
/// This protocol provides methods to perform network requests asynchronously and handle responses
/// using a completion handler that provides a `Result` object.
///
/// Types conforming to `HTTPClient` must implement both `get(from:headers:completion:)` and `post(_:to:headers:completion:)` methods.
public protocol HTTPClient: AnyObject {
    
    /// A type alias that represents the result of an HTTP request.
    ///
    /// - success: The request was successful, and the associated value contains the data returned by the server.
    /// - failure: The request failed, and the associated value contains the error.
    typealias Result = Swift.Result<Data?, HTTPClientError>
    
    /// Sends an asynchronous `GET` request to the specified URL.
    ///
    /// - Parameters:
    ///   - url: The URL to send the request to.
    ///   - headers: Optional HTTP headers to include in the request. Headers may have a value of `nil` which should be handled by the conforming client.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    ///
    /// - Note: The result is provided asynchronously on the completion handler, and the method returns immediately.
    ///
    /// Example usage:
    /// ```swift
    /// let task = client.get(from: url, headers: nil) { result in
    ///     switch result {
    ///     case .success(let data):
    ///         // Handle successful response with data
    ///     case .failure(let error):
    ///         // Handle error
    ///     }
    /// }
    ///
    @discardableResult
    func get(from url: URL, headers: [String: Any?]?, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    /// Sends an asynchronous `POST` request to the specified URL with the given data.
    ///
    /// - Parameters:
    ///   - data: The data to be sent in the body of the `POST` request.
    ///   - url: The URL to send the request to.
    ///   - headers: Optional HTTP headers to include in the request. Headers may have a value of `nil` which should be handled by the conforming client.
    ///   - completion: A closure to be called upon completion of the request. It receives a `Result` containing either the data or an error.
    /// - Returns: A task that allows for cancellation or monitoring of the ongoing request.
    ///
    /// - Note: The result is provided asynchronously on the completion handler, and the method returns immediately.
    ///
    /// Example usage:
    /// ```swift
    /// let task = client.post(data, to: url, headers: nil) { result in
    ///     switch result {
    ///     case .success(let data):
    ///         // Handle successful response with data
    ///     case .failure(let error):
    ///         // Handle error
    ///     }
    /// }
    /// ```
    @discardableResult
    func post(_ data: Data, to url: URL, headers: [String: Any?]?, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
