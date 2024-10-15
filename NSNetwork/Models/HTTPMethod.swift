//
//  HTTPMethod.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// An enumeration that represents common HTTP request methods.
///
/// `HTTPMethod` includes methods like `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`,
/// which are used when making network requests.
public enum HTTPMethod: String {
    
    /// The `GET` method is used to retrieve data from the server without making any changes.
    case GET
    
    /// The `POST` method is used to send data to the server, often when creating a new resource.
    case POST
    
    /// The `PUT` method is used to update or replace an existing resource on the server.
    case PUT
    
    /// The `PATCH` method is used to update parts of an existing resource.
    case PATCH
    
    /// The `DELETE` method is used to remove a resource from the server.
    case DELETE
}

