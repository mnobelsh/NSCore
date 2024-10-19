//
//  HTTPError.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// An error type that represents various failures that can occur when making HTTP requests.
///
/// The `HTTPError` enum defines specific cases for different types of errors such as invalid data,
/// invalid responses, client errors, server errors, and unknown errors.
public enum HTTPError: Swift.Error, Equatable {
    
    /// The URL provided was invalid.
    case invalidURL
    
    /// The data returned from the server was invalid or corrupted.
    case invalidData
    
    /// The response received from the server was invalid or unrecognized.
    case invalidResponse
    
    /// A client-side error occurred (e.g., 4xx status codes).
    ///
    /// - Parameters:
    ///   - data: The optional data returned from the server.
    ///   - code: The HTTP status code associated with the client error.
    case client(data: Data?, code: Int)
    
    /// A server-side error occurred (e.g., 5xx status codes).
    ///
    /// - Parameters:
    ///   - data: The optional data returned from the server.
    ///   - code: The HTTP status code associated with the server error.
    case server(data: Data?, code: Int)
    
    /// An unknown error occurred.
    ///
    /// - Parameter message: An optional message describing the error.
    case unknown(message: String?)
}

