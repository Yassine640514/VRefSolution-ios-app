//
//  VideoResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 04/01/2023.
//

import Foundation

struct VideoResponse: Decodable {
    let id: String
    let videoContainerName: String?
    let videoURL: String?
    let timeExpire: String
    let sessionId: String
    let logbookId: String
}

struct VideoCreateRequestBody: Codable {
    let videoUrl: String
    let sessionId: String
    let videoContainerName: String
}

struct VideoUpdateRequestBody: Codable {
    let VideoId: String
    let VideoURL: String
    
}
