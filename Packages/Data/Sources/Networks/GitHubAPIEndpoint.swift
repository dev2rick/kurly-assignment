//
//  GitHubAPIEndpoint.swift
//  Data
//
//  Created by rick on 12/16/25.
//

import Foundation

public enum GitHubAPIEndpoint {

    case fetchRepositories(query: String, page: Int)

    var path: String {
        switch self {
        case .fetchRepositories: "/search/repositories"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case let .fetchRepositories(query, page):
            [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page", value: "\(page)")]
        }
    }

    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
