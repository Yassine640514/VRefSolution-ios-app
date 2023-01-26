//
//  PlayerView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 07/01/2023.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    var videoLink : String
    @State private var player : AVPlayer?
    
    var body: some View {
        
        VStack{
            VideoPlayer(player: player) {

            }
            .onAppear() {
                guard let url = URL(string: videoLink) else {
                    return
                }
                player = AVPlayer(url: url)
                player?.play()
            }
            .onDisappear() {
                player?.pause()
            }
            
        }.frame(width: 888, height: 492)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(videoLink: "https://msvrefsolutions002-euwe.streaming.media.azure.net/f287bb8a-e8c4-4d40-8a10-80ba4cc121ba/5d3953cb-4858-4126-a4a7-97dab2683581.ism/manifest(format=m3u8-cmaf)") .previewInterfaceOrientation(.landscapeLeft)
    }
}
