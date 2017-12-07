//
//  UserViewModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol UserViewModelDelegate: class {
    func didReceiveUsersList(users: [User])
    func didFailDownloadUsersListWithError(error: Error)
}

class UserViewModel {
    
    typealias UserListResult = [[String: Any]]
    
    weak var delegate: UserViewModelDelegate?
    
    func requestUserList(url: String, since: Int) {
        Alamofire.request("\(url)\(since)").responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching users list: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailDownloadUsersListWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? UserListResult else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailDownloadUsersListWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUsersList(withResponse: responseJSON)
        }
    }
    
    private func setUsersList(withResponse response: UserListResult) {
        var usersArray = [User]()
        
        for data in response {
            if let user = User(json: data) {
                usersArray.append(user)
            }
        }
        
        delegate?.didReceiveUsersList(users: usersArray)
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
            os_log("Failed to save users.", log: OSLog.default, type: .error)
        }
    }
    
    func loadUsers() -> [User]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
}
