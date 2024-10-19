//
//  CodableStorage.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 19/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//
import Foundation

public protocol CodableStorage {
    func save(_ item: CodableItem, withKey key: String)
    func get(withKey key: String) -> CodableItem?
}
