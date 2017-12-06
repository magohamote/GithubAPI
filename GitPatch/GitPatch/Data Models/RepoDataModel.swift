//
//  RepoDataModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

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
        var reposArray = [Repo]()
        
        for data in response {
            if let repo = Repo(json: data) {
                reposArray.append(repo)
            }
        }
        
        delegate?.didReceiveDataUpdate(repos: reposArray)
    }
}
