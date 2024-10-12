//
//  HTTPMethod.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// An enumeration that defines HTTP request methods.
///
/// `HTTPMethod` provides an abstraction over the common HTTP methods such as `GET` and `POST`.
public enum HTTPMethod: String {
    
    /// The `GET` method is used to retrieve data from the server.
    case GET
    
    /// The `POST` method is used to send data to the server.
    case POST
    
    case PUT
    
    case PATCH
    
    case DELETE
}
