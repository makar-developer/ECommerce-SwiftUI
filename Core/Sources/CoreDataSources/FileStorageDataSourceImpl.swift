//
//  FileStorageDataSourceImpl.swift
//
//
//  Created by Admin on 16/12/2024.
//

import Foundation

public protocol FileStorageDataSourceProtocol {
    func save(data: Data, to directory: FileManager.SearchPathDirectory, with fileName: String) throws
    func load(from directory: FileManager.SearchPathDirectory, with fileName: String) throws -> Data
    func delete(from directory: FileManager.SearchPathDirectory, with fileName: String) throws
}

public final class FileStorageDataSourceImpl: FileStorageDataSourceProtocol {
    public init() {}

    public func save(data: Data, to directory: FileManager.SearchPathDirectory, with fileName: String) throws {
        let url = try getURL(for: directory).appendingPathComponent(fileName)
        try data.write(to: url)
    }

    public func load(from directory: FileManager.SearchPathDirectory, with fileName: String) throws -> Data {
        let url = try getURL(for: directory).appendingPathComponent(fileName)
        return try Data(contentsOf: url)
    }

    public func delete(from directory: FileManager.SearchPathDirectory, with fileName: String) throws {
        let url = try getURL(for: directory).appendingPathComponent(fileName)
        try FileManager.default.removeItem(at: url)
    }

    private func getURL(for directory: FileManager.SearchPathDirectory) throws -> URL {
        guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
            throw FileStorageError.directoryNotFound
        }
        return url
    }
}

public enum FileStorageError: Error {
    case directoryNotFound
}
