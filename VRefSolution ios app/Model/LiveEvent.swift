//
//  LiveEvent.swift
//  VRefSolution ios app
//
//  Created by Yassine on 06/01/2023.
//

import Foundation

struct LiveEvent{
    
    let name: StreamingCameras
    let stopLive: LiveEventStatus?
    let hls: String?
    var assetName: String{
        return "vrefsolutions"
    }
    
}

enum LiveEventStatus : String {
    //starts livestream
    case Run = "false"
    
    //stops livestram
    case Stop = "true"
}
