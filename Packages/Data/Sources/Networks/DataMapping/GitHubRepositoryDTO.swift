//
//  GitHubRepositoryDTO.swift
//  Data
//
//  Created by rick on 12/16/25.
//

import Domain

struct GitHubRepoResponseDTO: Decodable {
    let totalCount: Int
    let items: [GitHubRepoDTO]
}

struct GitHubRepoDTO: Decodable {
    let id: Int
    let name: String
    let owner: OwnerDTO
    
    struct OwnerDTO: Decodable {
        let login: String
        let avatarUrl: String
    }
}

extension GitHubRepoDTO {
    var toDomain: GitHubRepo {
        GitHubRepo(
            title: name,
            description: owner.login,
            thumbnailUrl: owner.avatarUrl
        )
    }
}
