//
//  Storage.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 19/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//

import Foundation

public protocol Storage {
    func save<T>(_ value: T, withKey key: String)
    func get<T>(withKey key: String) -> T?
    func delete(withKey key: String)
    func deleteAll()
}
