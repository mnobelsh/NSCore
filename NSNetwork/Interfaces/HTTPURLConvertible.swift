//
//  HTTPURLConvertible.swift
//  NSNetwork
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

public protocol HTTPURLConvertible {
    var value: URL { get }
}
extension String: HTTPURLConvertible {}
extension URL: HTTPURLConvertible {}

extension HTTPURLConvertible where Self == String {
    public var value: URL { URL(string: self)! }
}

extension HTTPURLConvertible where Self == URL {
    public var value: URL { self }
}
