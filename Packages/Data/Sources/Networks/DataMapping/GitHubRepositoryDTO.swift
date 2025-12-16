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
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct GitHubRepoDTO: Decodable {
    let id: Int
    let name: String
    let owner: OwnerDTO
    let htmlUrl: String
    
    struct OwnerDTO: Decodable {
        let login: String
        let avatarUrl: String
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case htmlUrl = "html_url"
    }
}

extension GitHubRepoDTO {
    var toDomain: GitHubRepo {
        GitHubRepo(
            title: name,
            description: owner.login,
            thumbnailUrl: owner.avatarUrl,
            url: htmlUrl
        )
    }
}
