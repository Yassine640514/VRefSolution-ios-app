//
//  PlayerView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 07/01/2023.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    //@ObservedObject var model = VideoModel()
    
    var videoLink : String
    
    @State private var player : AVPlayer?
    
    var body: some View {
        
        VStack{
            VideoPlayer(player: player) {
                //            VStack {
                //                Text("\(videoLink)")
                //                    .foregroundColor(.white)
                //                Spacer()
                //            }
            }//.frame(width: 600, height: 350)
            //.frame.size = CGSize(100,100)
            .onAppear() {
                guard let url = URL(string: videoLink) else {
                    return
                }
                player = AVPlayer(url: url)
                player?.play()
            }
            .onDisappear() {
                player?.pause()
            }//.ignoresSafeArea()
            
        }.frame(width: 888, height: 492)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(videoLink: "https://msvrefsolutions002-euwe.streaming.media.azure.net/f287bb8a-e8c4-4d40-8a10-80ba4cc121ba/5d3953cb-4858-4126-a4a7-97dab2683581.ism/manifest(format=m3u8-cmaf)") .previewInterfaceOrientation(.landscapeLeft)
    }
}
//goed
//"https://msvrefsolutions002-euwe.streaming.media.azure.net/50eefea7-2226-4fa5-b401-3cfeab1d976a/f50edb66-838f-46c2-bbc0-b60e4f1343f9.ism/manifest(format=m3u8-cmaf)"

//fout
//"https://msvrefsolutions002-euwe.streaming.media.azure.net/f287bb8a-e8c4-4d40-8a10-80ba4cc121ba/5d3953cb-4858-4126-a4a7-97dab2683581.ism/manifest(format=m3u8-cmaf)"
