//
//  UserDefaultsStorage.swift
//  NSCore
//
//  Created by Muhammad Nobel Shidqi on 19/10/24.
//  Copyright © 2024 Muhammad Nobel Shidqi. All rights reserved.
//
import Foundation

public final class UserDefaultsStorage: Storage, CodableStorage {
    private let suiteName: String?
    private let defaults: UserDefaults
    
    public init(suiteName: String? = nil) {
        self.suiteName = suiteName
        if let suiteName = suiteName {
            self.defaults = UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
        } else {
            self.defaults = UserDefaults.standard
        }
    }
    
    public func save<T>(_ value: T, withKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func save(_ item: CodableItem, withKey key: String) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(item)
        defaults.set(data, forKey: key)
    }
    
    public func get<T>(withKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    public func get<T: CodableItem>(withKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    public func delete(withKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    public func deleteAll() {
        if let suiteName = self.suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        } else {
            if let bundleIdentifier = Bundle.main.bundleIdentifier {
                defaults.removePersistentDomain(forName: bundleIdentifier)
            }
        }
    }
}
