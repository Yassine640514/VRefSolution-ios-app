//
//  StreamingResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 06/01/2023.
//

import Foundation

struct StreamingResponse: Decodable {
    let LiveEventName: String
    let StopLiveBool: String
    let HLS: String
}

struct StreamingRequestBody: Codable {
    let LiveEventName: String
    let StopLiveBool: String
    let NewAssetName: String
}

struct StreamingAssetsResponse: Decodable {
    let StreamName: String
    let Description: String?
    let StreamStatus: String
    let IngestURL: String
    let PreviewURL: String
}
