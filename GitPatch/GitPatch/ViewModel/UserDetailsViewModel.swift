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
    
    weak var delegate: UserDetailsViewModelDelegate?
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }

    func requestUserDetails(url: String) {
        service.requestUserDetails(url: url, completion: setUserDetails)
    }
    
    private func setUserDetails(withResponse response: Service.UniqueResult?, error: Error?) {
        guard let response = response else {
            if let error = error {
                delegate?.didFailDownloadUserDetailsWithError(error: error)
            }
            return
        }
        
        if let user = User(json: response) {
            delegate?.didReceiveUserDetails(user: user)
        }
    }
}
