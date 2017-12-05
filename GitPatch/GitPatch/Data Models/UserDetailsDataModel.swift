//
//  UserDetailsDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import Alamofire

protocol UserDetailsDataModelDelegate: class {
    func didReceiveAmountOfFollowers(followers: Int)
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
                    print("Error while fetching data: \(error)")
                    self.delegate?.didFailWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [[String: Any]] else {
                print("Invalid data received from the service")
                self.delegate?.didFailWithError(error: FormatError.badFormatError)
                return
            }
            
            setAmountOfData(responseJSON)
        }
    }
    
    func requestAmountOfFollowers(url: String) {
        requestAmountOfData(url: url, setAmountOfData: setAmountOfFollowers)
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
    
    private func setAmountOfFollowers(response: [[String: Any]]) {
        delegate?.didReceiveAmountOfFollowers(followers: response.count)
    }
    
    private func setAmountOfStars(response: [[String: Any]]) {
        delegate?.didReceiveAmountOfStars(stars: response.count)
    }
}
