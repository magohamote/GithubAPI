//
//  Repo.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation

class Repo: NSObject {
    var name: String
    var stargazersCount: Int
    var language: String
    var forksCount: Int
    var repoDescription: String
    var updatedAt: String
    
    init?(json: [String : Any]?) {
        if let name = json?["name"] as? String,
            let stargazersCount = json?["stargazers_count"] as? Int,
            let language = json?["language"] as? String,
            let forksCount = json?["forks_count"] as? Int,
            let repoDescription = json?["description"] as? String,
            let updatedAt = json?["updated_at"] as? String {
            
            self.name = name
            self.stargazersCount = stargazersCount
            self.language = language
            self.forksCount = forksCount
            self.repoDescription = repoDescription
            self.updatedAt = updatedAt
        } else {
            return nil
        }
    }
}
