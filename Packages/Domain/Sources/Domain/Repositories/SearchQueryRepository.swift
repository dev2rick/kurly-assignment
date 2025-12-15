//
//  SearchQueryRepository.swift
//  Domain
//
//  Created by rick on 12/15/25.
//

import Foundation

public protocol SearchQueryRepository {
    func save(searchQuery: String) async throws
    func fetchAll(query: String?, limit: Int) async throws -> [SearchQuery]
    func fetchOne(query: String) async throws -> SearchQuery?
    func remove(searchQuery: String) async throws
    func removeAll() async throws
}
