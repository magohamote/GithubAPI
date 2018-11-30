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
    
    private var service = Service()
    
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
            if let repo = Repo(withJson: data) {
                reposArray.append(repo)
            }
        }
        
        if response.count != reposArray.count {
            delegate?.didFailDownloadReposWithError(error: FormatError.badFormatError)
        } else {
            delegate?.didReceiveRepos(repos: reposArray)
        }
    }
    
    func saveRepos(forUserId userId: String, repos: [Repo]) {
        do {
            var data = Data()
            if repos.count > 100 {
                data = try PropertyListEncoder().encode(Array(repos[0..<100]))
            } else {
                data = try PropertyListEncoder().encode(repos)
            }
            
            guard let archiveURLAbsoluteString = Repo.ArchiveURL?.absoluteString,
                let archiveURL = URL(string: "\(archiveURLAbsoluteString)\(userId)") else {
                return
            }
            
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: archiveURL.path)
            if success {
                os_log("User's repos successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save user's repos.", log: OSLog.default, type: .error)
            }
        } catch {
            os_log("Failed to save user's repos.", log: OSLog.default, type: .error)
        }
    }
    
    func loadRepos(forUserId userId: String) -> [Repo]? {
        guard let archiveURLAbsoluteString = Repo.ArchiveURL?.absoluteString,
            let archiveURL = URL(string: "\(archiveURLAbsoluteString)\(userId)"),
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Data else {
            os_log("Failed to load user's repos.", log: OSLog.default, type: .error)
            return nil
        }
        do {
            let users = try PropertyListDecoder().decode([Repo].self, from: data)
            os_log("User's repos successfully loaded.", log: OSLog.default, type: .debug)
            return users
        } catch {
            os_log("Failed to load user's repos.", log: OSLog.default, type: .error)
            return nil
        }
    }
}
