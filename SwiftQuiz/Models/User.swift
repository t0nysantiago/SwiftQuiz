//
//  User.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import Foundation
import CryptoKit
import SwiftData

@Model
final public class User {
    
    @Attribute(.unique) public var id: String
    @Attribute(.unique) var username: String
    @Attribute(.unique) var email: String
    var img_name: String
    var password: String
    
    init(username: String = "",
         email: String = "",
         password: String = ""
    ) {
        self.id = UUID().uuidString
        self.username = username
        self.email = email
        self.img_name = "userlogo"
        self.password = ""
        self.setPassword(password)
    }
    
    private func setPassword(_ password: String) {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        self.password = hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
