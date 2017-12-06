//
//  User.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")
    
    var login: String
    var id: Int
    var avatarUrl: String
    var followersUrl: String
    var followingUrl: String
    var starredUrl: String
    var reposUrl: String
    
    struct Keys {
        static let login = "login"
        static let id = "id"
        static let avatarUrl = "avatarUrl"
        static let followersUrl = "followersUrl"
        static let followingUrl = "followingUrl"
        static let starredUrl = "starredUrl"
        static let reposUrl = "reposUrl"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let login = aDecoder.decodeObject(forKey: Keys.login) as! String
        let id = aDecoder.decodeInteger(forKey: Keys.id)
        let avatarUrl = aDecoder.decodeObject(forKey: Keys.avatarUrl) as! String
        let followersUrl = aDecoder.decodeObject(forKey: Keys.followersUrl) as! String
        let followingUrl = aDecoder.decodeObject(forKey: Keys.followingUrl) as! String
        let starredUrl = aDecoder.decodeObject(forKey: Keys.starredUrl) as! String
        let reposUrl = aDecoder.decodeObject(forKey: Keys.reposUrl) as! String

        self.init(login: login, id: id, avatarUrl: avatarUrl, followersUrl: followersUrl, followingUrl: followingUrl, starredUrl: starredUrl, reposUrl: reposUrl)
    }
    
    init?(login: String, id: Int, avatarUrl: String, followersUrl: String, followingUrl: String, starredUrl: String, reposUrl: String) {
        self.login = login
        self.id = id
        self.avatarUrl = avatarUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.starredUrl = starredUrl
        self.reposUrl = reposUrl
    }
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey: Keys.login)
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(avatarUrl, forKey: Keys.avatarUrl)
        aCoder.encode(followersUrl, forKey: Keys.followersUrl)
        aCoder.encode(followingUrl, forKey: Keys.followingUrl)
        aCoder.encode(starredUrl, forKey: Keys.starredUrl)
        aCoder.encode(reposUrl, forKey: Keys.reposUrl)
    }
}
