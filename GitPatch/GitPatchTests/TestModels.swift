//
//  TestModels.swift
//  GitPatchTests
//
//  Created by Rolland Cédric on 07.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import XCTest
import Foundation
@testable import GitPatch

class TestModels: XCTestCase {
    
    // MARK: - User Model
    
    func testSuccesfulUserJsonInit() {
        let data = getTestData(name: "user_details")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNotNil(User(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    func testSuccessfulUserInit() {
        XCTAssertNotNil(User.init(login: "test", id: 0, url: "test", avatarUrl: "test", followersUrl: "test", reposUrl: "test", location: "test", repos: 0, followers: 0, following: 0))
    }
    
    func testFailingUserJsonInit() {
        let data = getTestData(name: "bad_user_details")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(User(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    // MARK: - Repo Model
    
    func testSuccesfulRepoJsonInit() {
        let data = getTestData(name: "repo")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNotNil(Repo(json: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    func testFailingRepoJsonInit() {
        let data = getTestData(name: "bad_repo")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(Repo(json: jsonData))
        } catch {
            XCTFail()
        }
    }
}

