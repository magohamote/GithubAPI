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
    var url: String
    var avatarUrl: String
    var followersUrl: String
    var reposUrl: String
    var location: String?
    var repos: Int?
    var followers: Int?
    var following: Int?
    
    struct Keys {
        static let login = "login"
        static let id = "id"
        static let url = "url"
        static let avatarUrl = "avatarUrl"
        static let followersUrl = "followersUrl"
        static let reposUrl = "reposUrl"
        static let location = "location"
        static let repos = "repos"
        static let followers = "followers"
        static let following = "following"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let login = aDecoder.decodeObject(forKey: Keys.login) as? String,
            let url = aDecoder.decodeObject(forKey: Keys.url) as? String,
            let avatarUrl = aDecoder.decodeObject(forKey: Keys.avatarUrl) as? String,
            let followersUrl = aDecoder.decodeObject(forKey: Keys.followersUrl) as? String,
            let reposUrl = aDecoder.decodeObject(forKey: Keys.reposUrl) as? String {
            
            let id = aDecoder.decodeInteger(forKey: Keys.id)
            let location = aDecoder.decodeObject(forKey: Keys.location) as? String
            let repos = aDecoder.decodeInteger(forKey: Keys.repos)
            let followers = aDecoder.decodeInteger(forKey: Keys.followers)
            let following = aDecoder.decodeInteger(forKey: Keys.following)
            
            self.init(login: login, id: id, url: url, avatarUrl: avatarUrl, followersUrl: followersUrl, reposUrl: reposUrl, location: location, repos: repos, followers: followers, following: following)
        } else {
            return nil
        }
    }
    
    init?(login: String, id: Int, url: String, avatarUrl: String, followersUrl: String, reposUrl: String, location: String?, repos: Int?, followers: Int?, following: Int?) {
        self.login = login
        self.id = id
        self.url = url
        self.avatarUrl = avatarUrl
        self.followersUrl = followersUrl
        self.reposUrl = reposUrl
        self.location = location
        self.repos = repos
        self.followers = followers
        self.following = following
    }
    
    init?(json: [String : Any]?) {
        if let login = json?["login"] as? String,
            let id = json?["id"] as? Int,
            let url = json?["url"] as? String,
            let avatarUrl = json?["avatar_url"] as? String,
            let followersUrl = json?["followers_url"] as? String,
            let reposUrl = json?["repos_url"] as? String {
            
            self.login = login
            self.id = id
            self.url = url
            self.avatarUrl = avatarUrl
            self.followersUrl = followersUrl
            self.reposUrl = reposUrl
        } else {
            return nil
        }
        
        location = json?["location"] as? String
        repos = json?["public_repos"] as? Int
        followers = json?["followers"] as? Int
        following = json?["following"] as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(login, forKey: Keys.login)
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(url, forKey: Keys.url)
        aCoder.encode(avatarUrl, forKey: Keys.avatarUrl)
        aCoder.encode(followersUrl, forKey: Keys.followersUrl)
        aCoder.encode(reposUrl, forKey: Keys.reposUrl)
        aCoder.encode(location, forKey: Keys.location)
        
        // encoding optional Int result in a crash when decoding Int
        if let _ = repos {
            aCoder.encode(repos!, forKey: Keys.repos)
        }
        if let _ = followers {
            aCoder.encode(followers!, forKey: Keys.followers)
        }
        if let _ = following {
            aCoder.encode(following!, forKey: Keys.following)
        }
    }
}
