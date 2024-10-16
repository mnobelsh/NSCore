//
//  URLConvertible.swift
//  NSNetwork
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

/// A protocol that provides a way to convert an object into a `URL`.
///
/// Conforming types must provide an `asURL` property that returns an optional `URL`.
/// This is useful when working with various types that can be represented as URLs, such as `String` and `URL`.
///
/// The protocol conforms to `Sendable`, meaning objects of conforming types can be safely used in concurrent code.
public protocol URLConvertible: Sendable {
    
    /// Converts the conforming type into a `URL`.
    ///
    /// - Returns: An optional `URL` if the conversion is successful, otherwise `nil`.
    var asURL: URL? { get }
}

// MARK: - URLConvertible + Implementations
extension String: URLConvertible {
    public var asURL: URL? { URL(string: self) }
}

extension URL: URLConvertible {
    public var asURL: URL? { self }
}

extension Optional: URLConvertible where Wrapped == URL {
    public var asURL: URL? { self }
}
