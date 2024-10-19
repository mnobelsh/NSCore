//
//  URLSessionHTTPClient+HTTPClientTask.swift
//  NSNetwork
//
//  Created by Muhammad Nobel Shidqi on 17/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

extension URLSessionHTTPClient {
    
    struct Task: HTTPClientTask {
        var id: String { UUID().uuidString }
        
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
}
