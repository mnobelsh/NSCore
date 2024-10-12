//
//  HTTPClientError.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

public enum HTTPClientError: Swift.Error, Equatable {
    case invalidData
    case invalidResponse
    case client(data: Data?, code: Int)
    case server(data: Data?, code: Int)
    case unknown(message: String?)
}
