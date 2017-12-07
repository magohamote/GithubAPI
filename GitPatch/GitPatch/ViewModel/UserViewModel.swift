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
        
    weak var delegate: UserViewModelDelegate?
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func requestUserList(url: String, since: Int) {
        service.requestUserList(since: since, completion: setUsersList)
    }
    
    private func setUsersList(withResponse response: Service.MultipleResult?, error: Error?) {
        guard let response = response else {
            if let error = error {
                delegate?.didFailDownloadUsersListWithError(error: error)
            }
            return
        }
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
        if let users = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User] {
            os_log("Users successfully loaded.", log: OSLog.default, type: .debug)
            return users
        }
        os_log("Users successfully loaded.", log: OSLog.default, type: .error)
        return nil
    }
}
