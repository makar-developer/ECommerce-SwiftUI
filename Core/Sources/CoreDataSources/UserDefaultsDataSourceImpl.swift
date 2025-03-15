//
//  UserDefaultsDataSourceImpl.swift
//
//
//  Created by Admin on 11/12/2024.
//

import Foundation

public protocol UserDefaultsDataSourceProtocol {
    func setObject<T: Codable>(_ object: T, forKey key: String)
    func getObject<T: Codable>(forKey key: String) -> T?
    func removeObject(forKey key: String)
}

public final class UserDefaultsDataSource: UserDefaultsDataSourceProtocol {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func setObject<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to encode object: \(error)")
        }
    }

    public func getObject<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Failed to decode object: \(error)")
            return nil
        }
    }

    public func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
