//
//  EventResponse.swift
//  VRefSolution ios app
//
//  Created by Yassine on 05/01/2023.
//

import Foundation

struct EventResponse: Decodable {
    let id: String
    let logbookId: String
    let timeStamp: Int
    let eventType: String
    let captain: String?
    let firstOfficer: String?
    let feedbackAll: String?
    let feedbackCaptain: String?
    let feedbackFirstOfficer: String?
    let ratingAll: Int?
    let ratingCaptain: Int?
    let ratingFirstOfficer: Int?
}

struct EventCreateRequestBody: Codable {
    let timeStamp: Int
    let eventType: String
    let logbookId: String
    let captain: String?
    let firstOfficer: String?
    let feedbackAll: String?
    let feedbackCaptain: String?
    let feedbackFirstOfficer: String?
    let ratingAll: Int?
    let ratingCaptain: Int?
    let ratingFirstOfficer: Int?
}

struct EventUpdateRequestBody: Codable {
    let feedbackAll: String?
    let feedbackCaptain: String?
    let feedbackFirstOfficer: String?
    let ratingAll: Int?
    let ratingCaptain: Int?
    let ratingFirstOfficer: Int?
}
