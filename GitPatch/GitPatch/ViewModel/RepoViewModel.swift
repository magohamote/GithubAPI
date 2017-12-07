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
    
    weak var delegate: RepoViewModelDelegate?
    
    internal var service = Service()
    
    func requestUserRepos(url: String) {
        service.requestUserRepos(url: url, completion: setUserRepos)
    }
    
    private func setUserRepos(withResponse response: Service.MultipleResult?, error: Error?) {
        guard let response = response else {
            if let error = error {
                delegate?.didFailDownloadReposWithError(error: error)
            } else {
                delegate?.didFailDownloadReposWithError(error: FormatError.badFormatError)
            }
            return
        }
        var reposArray = [Repo]()
        
        for data in response {
            if let repo = Repo(json: data) {
                reposArray.append(repo)
            }
        }
        
        if response.count != reposArray.count {
            delegate?.didFailDownloadReposWithError(error: FormatError.badFormatError)
        } else {
            delegate?.didReceiveRepos(repos: reposArray)
        }
    }
}
