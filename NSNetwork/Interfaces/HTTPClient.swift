//
//  HTTPClient.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

public protocol HTTPClient: AnyObject {
    typealias Result = Swift.Result<Data?, HTTPClientError>
    
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
    
    @discardableResult
    func post(_ data: Data, to url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
