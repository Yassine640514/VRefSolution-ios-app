//
//  Video.swift
//  VRefSolution ios app
//
//  Created by Yassine on 04/01/2023.
//

import Foundation

struct Video: Identifiable, Equatable{
    
    let id: String
    let videoName: String?
    var videoURL: String?
    let timeExpire: Date
    let sessionId: String
    let logbookId: String
    
}
    
