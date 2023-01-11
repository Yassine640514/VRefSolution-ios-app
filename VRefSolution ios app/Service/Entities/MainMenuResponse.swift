//
//  SessionResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 12/12/2022.
//

import Foundation

struct SessionResponse: Decodable {
    let videos: [String]?
    let id: String
    let startTime: String
    let status: String?
    let companyId: String
}

struct UserResponse: Decodable {
    let results: [UserEntity]
}

struct UserEntity: Decodable {
    let id: String
    let email: String
    let firstname: String
    let lastname: String
    let username: String
    let password: String
    let role: String
    let companyId: String
}

