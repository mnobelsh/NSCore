//
//  HTTPClientTask.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 12/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

/// A protocol that represents a task created by an `HTTPClient`.
///
/// Conforming types represent network tasks, providing functionality to manage the lifecycle of a task,
/// such as cancellation or resuming.
public protocol HTTPClientTask {
    
    /// A unique identifier for the task.
    var id: String { get }
    
    /// Cancels the task if it is currently running.
    ///
    /// The task will attempt to stop any ongoing work, such as a network request, and prevent further results from being delivered.
    func cancel()
}
