//
//  RepoViewModel.swift
//  GitPatch
//
//  Created by Rolland Cédric on 05.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import Alamofire
import os.log

protocol RepoViewModelDelegate: class {
    func didReceiveRepos(repos: [Repo])
    func didFailDownloadReposWithError(error: Error)
}

class RepoViewModel {
    
    typealias ReposResult = [[String: Any]]
    
    weak var delegate: RepoViewModelDelegate?
    
    func requestUserRepos(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    os_log("Error while fetching repositories: %@", log: OSLog.default, type: .debug, "\(error)")
                    self.delegate?.didFailDownloadReposWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? ReposResult else {
                os_log("Invalid data received from the service", log: OSLog.default, type: .debug)
                os_log("data: %@", log: OSLog.default, type: .debug, response.result.value.debugDescription)
                self.delegate?.didFailDownloadReposWithError(error: FormatError.badFormatError)
                return
            }
            
            self.setUserRepos(withResponse: responseJSON)
        }
    }
    
    private func setUserRepos(withResponse response: ReposResult) {
        var reposArray = [Repo]()
        
        for data in response {
            if let repo = Repo(json: data) {
                reposArray.append(repo)
            }
        }
        
        delegate?.didReceiveRepos(repos: reposArray)
    }
}
