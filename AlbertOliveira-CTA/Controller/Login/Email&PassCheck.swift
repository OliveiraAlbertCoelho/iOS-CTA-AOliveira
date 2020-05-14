//
//  email&PassCheck.swift
//  PursuitGramProj
//
//  Created by albert coelho oliveira on 11/19/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//
import Foundation
extension String {
    var isValidEmail: Bool {
        let validEmailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", validEmailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let validPasswordRegEx =  "[A-Z0-9a-z!@#$&*.-]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", validPasswordRegEx)
        return passwordPredicate.evaluate(with: self)
        
    }
}
