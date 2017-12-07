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
    
    typealias UserFollowersResult = [[String: Any]]
    
    weak var delegate: FollowersViewModelDelegate?
    
    func requestUserFollowers(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching followers: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailDownloadFollowersWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? UserFollowersResult else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailDownloadFollowersWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUsersFollowers(withResponse: responseJSON)
        }
    }
    
    private func setUsersFollowers(withResponse response: UserFollowersResult) {
        var followersArray = [User]()
        
        for data in response {
            if let follower = User(json: data) {
                followersArray.append(follower)
            }
        }
        
        delegate?.didReceiveUsersFollowers(followers: followersArray)
    }
}

