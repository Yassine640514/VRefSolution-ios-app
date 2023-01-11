//
//  StreamingAssets.swift
//  VRefSolution ios app
//
//  Created by Yassine on 06/01/2023.
//

import Foundation

struct StreamingAsset{
    
    let name: StreamingCameras
    let description: String?
    let status: StreamingStatus
    let ingestURL: String
    let previewURL: String
}

enum StreamingStatus : String {
    //starts livestream
    case Running //= "Stopped"
    
    //stops livestram
    case Stopped //= "Running"
}

enum StreamingCameras : String{
    case Camera1, Camera2, Camera3, Camera4, Camera5
}
