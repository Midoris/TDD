//
//  APIClient.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 24/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import Foundation

class APIClient {

    lazy var session: ToDoURLSession = URLSession.shared
    var keychainManager: KeychainAccessible?

    func loginUser(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        let allowedCharacters = CharacterSet(charactersIn: "/%=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        guard let url = URL(string: "https://asesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else {
            fatalError()
        }
        let task = session.dataTask(with: url) { (data, responss, error) in
            if error != nil {
                completion(WebServiceError.responseError)
                return
            }
            if let theData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: theData, options: [])
                    if let responseDict = jsonObject as? [String: String] {
                        let token = responseDict["token"]
                        self.keychainManager?.set(password: token!, account: "token")
                    }
                } catch {
                    completion(error)
                }
            } else {
                completion(WebServiceError.dataEmptyError)
            }
        }
        task.resume()
    }
}

enum WebServiceError: Error {
    case dataEmptyError
    case responseError
}

protocol ToDoURLSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: ToDoURLSession {
}
