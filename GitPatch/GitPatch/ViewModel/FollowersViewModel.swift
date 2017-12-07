//
//  FollowersViewModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 07.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol FollowersViewModelDelegate: class {
    func didReceiveUsersFollowers(followers: [User])
    func didFailDownloadFollowersWithError(error: Error)
}

class FollowersViewModel {
    
    weak var delegate: FollowersViewModelDelegate?
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func requestUserFollowers(url: String) {
        service.requestUserFollowers(url: url, completion: setUsersFollowers)
    }
    
    private func setUsersFollowers(withResponse response: Service.MultipleResult?, error: Error?) {
        guard let response = response else {
            if let error = error {
                delegate?.didFailDownloadFollowersWithError(error: error)
            }
            return
        }
        var followersArray = [User]()
        
        for data in response {
            if let follower = User(json: data) {
                followersArray.append(follower)
            }
        }
        
        delegate?.didReceiveUsersFollowers(followers: followersArray)
    }
}

