//
//  UserDetailsDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol UserDetailsDataModelDelegate: class {
    func didReceiveUsersFollowers(followers: [User])
    func didReceiveUserDetails(user: User)
    func didFailWithError(error: Error)
}

class UserDetailsDataModel {
    
    weak var delegate: UserDetailsDataModelDelegate?
    
    func requestUserDetails(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching data: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any] else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUserDetails(response: responseJSON)
        }
    }
    
    func requestUsersFollowers(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching data: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [[String: Any]] else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUsersFollowers(response: responseJSON)
        }
    }
    
    private func setUserDetails(response: [String: Any]) {
        if let user = User(json: response) {
            delegate?.didReceiveUserDetails(user: user)
        }
    }
    
    
    private func setUsersFollowers(response: [[String: Any]]) {
        var followersArray = [User]()
        
        for data in response {
            if let follower = User(json: data) {
                followersArray.append(follower)
            }
        }
        
        delegate?.didReceiveUsersFollowers(followers: followersArray)
    }
}
