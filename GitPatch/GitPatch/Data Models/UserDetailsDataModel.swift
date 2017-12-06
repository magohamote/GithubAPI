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
    func didReceiveFollowers(followers: [User])
    func didReceiveAmountOfFollowing(following: Int)
    func didReceiveAmountOfStars(stars: Int)
    func didFailWithError(error: Error)
}

class UserDetailsDataModel {
    
    weak var delegate: UserDetailsDataModelDelegate?
    
    private func requestAmountOfData(url: String, setAmountOfData: @escaping (_: [[String: Any]])->Void) {
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
            
            setAmountOfData(responseJSON)
        }
    }
    
    func requestAmountOfFollowers(url: String) {
        requestAmountOfData(url: url, setAmountOfData: setFollowers)
    }
    
    func requestAmountOfFollowing(url: String) {
        requestAmountOfData(url: url, setAmountOfData: setAmountOfFollowing)
    }
    
    func requestAmountOfStars(url: String) {
        requestAmountOfData(url: url, setAmountOfData: setAmountOfStars)
    }

    private func setAmountOfFollowing(response: [[String: Any]]) {
        delegate?.didReceiveAmountOfFollowing(following: response.count)
    }
    
    private func setAmountOfStars(response: [[String: Any]]) {
        delegate?.didReceiveAmountOfStars(stars: response.count)
    }
    
    private func setFollowers(response: [[String: Any]]) {
        var followersArray = [User]()
        
        for data in response {
            if let follower = User(json: data) {
                followersArray.append(follower)
            }
        }
        
        delegate?.didReceiveFollowers(followers: followersArray)
    }
}
