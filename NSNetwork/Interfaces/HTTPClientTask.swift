//
//  HTTPClientTask.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

public protocol HTTPClientTask {
    var id: String { get }
    
    func cancelTask()
    func resumeTask()
}
