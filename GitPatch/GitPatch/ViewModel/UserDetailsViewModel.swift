//
//  UserDetailsViewModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol UserDetailsViewModelDelegate: class {
    func didReceiveUserDetails(user: User)
    func didFailDownloadUserDetailsWithError(error: Error)
}

class UserDetailsViewModel {
    
    typealias UserDetailResult = [String: Any]
    weak var delegate: UserDetailsViewModelDelegate?
    
    func requestUserDetails(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching user details: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailDownloadUserDetailsWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? UserDetailResult else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailDownloadUserDetailsWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUserDetails(withResponse: responseJSON)
        }
    }
    
    private func setUserDetails(withResponse response: UserDetailResult) {
        if let user = User(json: response) {
            delegate?.didReceiveUserDetails(user: user)
        }
    }
}
