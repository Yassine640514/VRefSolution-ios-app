//
//  AuthenticationError.swift
//  VRefSolution ios app
//
//  Created by Yassine on 05/12/2022.
//

import Foundation

enum AuthenticationError: Error {
    case usernameOrPasswordEmpty
    case invalidCredentials
    case custom(errorMessage: String)
}

extension AuthenticationError: LocalizedError{
    
    var errorDescription: String?{
        switch self{
        case .usernameOrPasswordEmpty:
            return "Username and/or password fields not filled in"
        case .invalidCredentials:
            return "Invalid username and/or password filled in"
        case .custom(errorMessage: let errorMessage):
            return "\(errorMessage)"
        }
    }
}

