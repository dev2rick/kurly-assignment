//
//  GitHubAPIService.swift
//  Data
//
//  Created by rick on 12/16/25.
//

import Foundation

public protocol NetworkLogger: Sendable {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

public protocol GitHubAPIService: Sendable {
    func request<T: Decodable>(_ endpoint: GitHubAPIEndpoint) async throws -> T
}

public final class GitHubAPIServiceImpl: GitHubAPIService {
    private let logger: NetworkLogger
    
    public init(logger: NetworkLogger) {
        self.logger = logger
    }

    public func request<T: Decodable>(_ endpoint: GitHubAPIEndpoint) async throws -> T {
        do {
            guard let request = endpoint.makeRequest() else {
                throw URLError(.badURL)
            }
            logger.log(request: request)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            logger.log(responseData: data, response: response)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()

            return try decoder.decode(T.self, from: data)
        } catch {
            logger.log(error: error)
            throw error
        }
    }
}

