//
//  APIClientTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 24/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {

    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUSerNameAndPassword() {
        let completion = { (error: Error?) in }
        sut.loginUser(with: "dasdöm", password: "%&34", completion: completion)
        XCTAssertNotNil(mockURLSession.completionHendler)
        guard let url = mockURLSession.url else {
            fatalError()
            return
        }
        let urlsComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let allowedCharacters = CharacterSet(charactersIn: "/%=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let expectedsername = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        XCTAssertEqual(urlsComponents?.percentEncodedQuery, "username=\(expectedsername)&password=\(expectedPassword)")
    }

    func testLogin_CallsResumeOfDataTask() {
        sut.session = mockURLSession
        let completion = { (error: Error?) in }
        sut.loginUser(with: "dasdom", password: "1234", completion: completion)
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }

    func testLogin_SetsToken() {
        let mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        let completion = { (error: Error?) in }
        sut.loginUser(with: "dasdom", password: "1234", completion: completion)
        let responseDict = ["token": "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        mockURLSession.completionHendler?(responseData, nil, nil)
        let token = mockKeychainManager.password(for: "token")
        XCTAssertEqual(token, responseDict["token"])
    }

    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUser(with: "dasdom", password: "1234", completion: completion)
        let responseData = Data()
        mockURLSession.completionHendler?(responseData, nil, nil)
        XCTAssertNotNil(theError)
    }

    func  testLogin_ThrowsErrorWhenDataIsNill() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUser(with: "dasdom", password: "1234", completion: completion)
        mockURLSession.completionHendler?(nil, nil, nil)
        XCTAssertNotNil(theError)
    }

    func testLogin_ThrowsErrorWhenResponseHesError() {
        var theError: Error?
        let completion = { (error: Error?) in
            theError = error
        }
        sut.loginUser(with: "dasdom", password: "1234", completion: completion)
        let responseDict = ["token": "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        let errorr = NSError(domain: "Some", code: 1234, userInfo: nil)
        mockURLSession.completionHendler?(responseData, nil, errorr)
        XCTAssertNotNil(theError)
    }

}

extension APIClientTests {

    class MockURLSession: ToDoURLSession {

        typealias Handler = (Data?, URLResponse?, Error?)
            -> Void
        var completionHendler: Handler?
        var url: URL?
        var dataTask = MockURLSessionDataTask()

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            self.completionHendler = completionHandler
            return dataTask
        }
    }

    class MockURLSessionDataTask: URLSessionDataTask {
        var resumeGotCalled = false

        override func resume() {
            resumeGotCalled = true
        }
    }

    class MockKeychainManager: KeychainAccessible {
        var passwordDict = [String: String]()

        func set(password: String, account: String) {
            passwordDict[account] = password
        }

        func deletePassword(for account: String) {
            passwordDict.removeValue(forKey: account)
        }

        func password(for account: String) -> String? {
            return passwordDict[account]
        }
    }
}
