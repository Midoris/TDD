//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 25/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func set(password: String, account: String)
    func deletePassword(for account: String)
    func password(for account: String) -> String?
}
