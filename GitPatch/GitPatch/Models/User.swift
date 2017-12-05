//
//  User.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation

class User: NSObject {
    var login: String
    var id: Int
    var avatarUrl: String
    var followersUrl: String
    var followingUrl: String
    var starredUrl: String
    var reposUrl: String
    
    init?(json: [String : Any]?) {
        if let login = json?["login"] as? String,
            let id = json?["id"] as? Int,
            let avatarUrl = json?["avatar_url"] as? String,
            let followersUrl = json?["followers_url"] as? String,
            let followingUrl = json?["following_url"] as? String,
            let starredUrl = json?["starred_url"] as? String,
            let reposUrl = json?["repos_url"] as? String {
            
            self.login = login
            self.id = id
            self.avatarUrl = avatarUrl
            self.followersUrl = followersUrl
            self.followingUrl = followingUrl
            self.starredUrl = starredUrl
            self.reposUrl = reposUrl
        } else {
            return nil
        }
    }
}
