//
//  UserDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import Alamofire

protocol UserDataModelDelegate: class {
    func didReceiveDataUpdate(users: [User])
    func didFailDataUpdateWithError(error: Error)
}

class UserDataModel {
    
    weak var delegate: UserDataModelDelegate?
    
    func requestData(url: String, since: Int) {
        Alamofire.request("\(url)\(since)").responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    print("Error while fetching data: \(error)")
                    self.delegate?.didFailDataUpdateWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [[String: Any]] else {
                print("Invalid data received from the service")
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
}
