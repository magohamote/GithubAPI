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
    var gravatarDd: String
    var url: String
    var htmlUrl: String
    var followersUrl: String
    var followingUrl: String
    var gistsUrl: String
    var starredUrl: String
    var subscriptionsUrl: String
    var organizationsUrl: String
    var reposUrl: String
    var eventsUrl: String
    var receivedEventsUrl: String
    var type: String
    var siteAdmin: Bool
    
    init?(json: [String : Any]?) {
        if let login = json?["login"] as? String,
            let id = json?["id"] as? Int,
            let avatarUrl = json?["avatar_url"] as? String,
            let gravatarDd = json?["gravatar_id"] as? String,
            let url = json?["url"] as? String,
            let htmlUrl = json?["html_url"] as? String,
            let followersUrl = json?["followers_url"] as? String,
            let followingUrl = json?["following_url"] as? String,
            let gistsUrl = json?["gists_url"] as? String,
            let starredUrl = json?["starred_url"] as? String,
            let subscriptionsUrl = json?["subscriptions_url"] as? String,
            let organizationsUrl = json?["organizations_url"] as? String,
            let reposUrl = json?["repos_url"] as? String,
            let eventsUrl = json?["events_url"] as? String,
            let receivedEventsUrl = json?["received_events_url"] as? String,
            let type = json?["type"] as? String,
            let siteAdmin = json?["site_admin"] as? Bool {
            
            self.login = login
            self.id = id
            self.avatarUrl = avatarUrl
            self.gravatarDd = gravatarDd
            self.url = url
            self.htmlUrl = htmlUrl
            self.followersUrl = followersUrl
            self.followingUrl = followingUrl
            self.gistsUrl = gistsUrl
            self.starredUrl = starredUrl
            self.subscriptionsUrl = subscriptionsUrl
            self.organizationsUrl = organizationsUrl
            self.reposUrl = reposUrl
            self.eventsUrl = eventsUrl
            self.receivedEventsUrl = receivedEventsUrl
            self.type = type
            self.siteAdmin = siteAdmin
        } else {
            return nil
        }
    }
}
