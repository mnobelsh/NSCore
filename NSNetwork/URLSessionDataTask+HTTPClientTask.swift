//
//  URLSessionDataTask+HTTPClientTask.swift
//  NSNetwork
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

extension URLSessionDataTask: HTTPClientTask {
    public var id: String { UUID().uuidString }
    
    public func cancelTask() {
        self.cancel()
    }
    
    public func resumeTask() {
        self.resume()
    }
}
