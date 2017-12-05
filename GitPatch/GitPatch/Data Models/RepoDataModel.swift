//
//  RepoDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Foundation
import Alamofire

protocol RepoDataModelDelegate: class {
    func didReceiveDataUpdate(repos: [Repo])
    func didFailDataUpdateWithError(error: Error)
}

class RepoDataModel {
    
    weak var delegate: RepoDataModelDelegate?
    
    func requestData(url: String) {
        Alamofire.request(url).responseJSON { response in
            
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
        var reposArray = [Repo]()
        
        for data in response {
            if let repo = Repo(json: data) {
                reposArray.append(repo)
            }
        }
        
        delegate?.didReceiveDataUpdate(repos: reposArray)
    }
}
