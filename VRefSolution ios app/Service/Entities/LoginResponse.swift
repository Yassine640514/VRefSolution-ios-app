//
//  LoginResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 27/11/2022.
//

import Foundation

struct LoginResponse: Decodable {
    let token: String?
    let tokenType: String?
}

struct LoginRequestBody: Codable {
    let username: String
    let password: String
}


