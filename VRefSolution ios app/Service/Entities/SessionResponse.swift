//
//  SessionResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 03/01/2023.
//

import Foundation

struct SessionCreateResponse: Decodable {
    let id: String
    let startTime: String
    let status: String?
    let companyId: String
    let videos: [String]?
}

struct SessionCreateRequestBody: Codable {
    let UserIds: [String]
    let CompanyId: String
}

struct SessionUpdate: Codable{
    
}
