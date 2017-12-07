//
//  GitPatchTests.swift
//  GitPatchTests
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import XCTest
import Foundation
import Alamofire
@testable import GitPatch

class GitPatchTests: XCTestCase {
    
    var usersListVC: UserListViewController!
    var htmlResponse: HTTPURLResponse!
    var userViewModel: UserViewModel!
    
    override func setUp() {
        super.setUp()
        usersListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UserListViewController.identifier) as! UserListViewController
        htmlResponse = HTTPURLResponse(url: NSURL(string: "dummyURL")! as URL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        userViewModel = UserViewModel()
    }
    
    override func tearDown() {
        usersListVC = nil
        htmlResponse = nil
        super.tearDown()
    }
    
    // MARK: - User Model
    
    func testSuccesfulUserJsonInit() {
        let data = getTestData(name: "user_details")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNotNil(User(json: jsonData))
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
            XCTAssertNil(User(json: jsonData))
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
    
    // MARK: - User View Model
    
    func testUserViewModel() {
        //
    }
    
    // MARK: VC data init
    
    func testGoodUsersList() {
        let data = getTestData(name: "users_list")
        MockRequest.response.data = htmlResponse
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            XCTFail()
        }
        
        _ = request("dummyURL").responseJSON { (request, response, JSON, error) -> Void in
            if let users = JSON as? [[String: Any]]{
                for user in users {
                    if let user = User(json: user) {
                        usersListVC.usersArray.append(user)
                    }
                }
                
                XCTAssertEqual(usersListVC.usersArray.count, 10)
            }
        }
    }
    
    func testGoodUserDetails() {
        let data = getTestData(name: "user_details")
        MockRequest.response.data = htmlResponse
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            XCTFail()
        }
        
        _ = request("dummyURL").responseJSON { (request, response, JSON, error) -> Void in
            if let user = JSON as? [String: Any]{
                XCTAssertNotNil(User(json: user))
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func getTestData(name: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: name, ofType: "json")
        return try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    }
    
    private func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) -> MockRequest {
        
        return MockRequest(request: url as! String)
    }
}
