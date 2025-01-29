//
//  File.swift
//  
//
//  Created by Admin on 07/12/2024.
//


import Foundation

public protocol NetworkServiceDataSourceProtocol {
    func request<T: Decodable>(endpoint: String) async throws -> T
}

public final class NetworkServiceDataSourceImpl: NetworkServiceDataSourceProtocol {
    private let baseURL: URL
    private let urlSession: URLSession

    public init(baseURL: URL, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    public func request<T: Decodable>(endpoint: String) async throws -> T {
        let urlString = baseURL.absoluteString + endpoint
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.badConnection
        }
    }
}

public enum NetworkError: LocalizedError {
    case badConnection

    public var errorDescription: String? {
        switch self {
        case .badConnection:
            return "Bad internet connection"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .badConnection:
            return "Try to check the internet connection or relaunch the app"
        }
    }
}
