//
//  RecordsResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 10/01/2023.
//

import Foundation

struct RecordResponse: Decodable {
    let id: String
    let timeStamp: Int
    let altitude: Int
    let logbookId: String
}

struct RecordCreateRequestBody: Codable {
    let timeStamp: Int
    let altitude: Int
    let logbookId: String
}
