//
//  UserDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol UserDataModelDelegate: class {
    func didReceiveDataUpdate(users: [User])
    func didFailDataUpdateWithError(error: Error)
}

class UserDataModel {
    
    weak var delegate: UserDataModelDelegate?
    
    func requestUserList(url: String, since: Int) {
        Alamofire.request("\(url)\(since)").responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching data: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailDataUpdateWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [[String: Any]] else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailDataUpdateWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setDataWithResponse(response: responseJSON)
        }
    }
    
    private func setDataWithResponse(response:[[String: Any]]) {
        var usersArray = [User]()
        
        for data in response {
            if let user = User(json: data) {
                usersArray.append(user)
            }
        }
        
        delegate?.didReceiveDataUpdate(users: usersArray)
    }
    
    func saveUsers(users: [User]) {
        var isSuccessfulSave = false
        if users.count > 100 { // save only up to 100 users for offline state
            isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Array(users[0..<100]), toFile: User.ArchiveURL.path)
        } else {
            isSuccessfulSave = NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)
        }
        if isSuccessfulSave {
            os_log("Users successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save users...", log: OSLog.default, type: .error)
        }
    }
    
    func loadUsers() -> [User]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
}
