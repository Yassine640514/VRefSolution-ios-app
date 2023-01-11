//
//  testPlayer.swift
//  VRefSolution ios app
//
//  Created by Yassine on 11/01/2023.
//

import SwiftUI


struct testPlayer: View {
    var body: some View {
 
        ZStack(){
            //
            //                Group(){
            //
            //                    HStack{
            //                        Spacer()
            //                        VideoPlayer(player: player)//.ignoresSafeArea()
            //                            .onAppear() {
            //                                player.play()
            //
            //                            }
            //                    }
            //                }.frame(width: 888, height: 492).border(.black).position(x:746, y: 300).zIndex(3)
            
            
            //Topbar
            NavigationView(){
                ScrollView(){
                    VStack(){
                        
                        Group(){
                            
                            HStack{
                                PlayerView(videoLink: "https://msvrefsolutions002-euwe.streaming.media.azure.net/5f3ca6e2-9919-4572-a221-a3dc89906e52/48c2aa29-4883-42c6-b249-a367a03ea02f.ism/manifest(format=m3u8-cmaf)")
                            }
                        }.frame(width: 888, height: 492).border(.black).position(x:746, y: 300).zIndex(3)
                        //background color
                        // Color("darkmodeColor2").edgesIgnoringSafeArea(.all)
                        
                        
                    }//.zIndex(-2)
                    
                    
                    
                    .toolbarBackground(Color("topbarColor"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Image("shortLogo").padding(.bottom,10)
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            VStack(alignment: .leading){
                                Text("Session Name")
                                    .font(.headline).fontWeight(.bold).foregroundColor(Color("buttonColorBlue")).bold().padding(.bottom, -9)
                                Text("Start Time")
                                    .font(.footnote).foregroundColor(.white).padding(.bottom, -8)
                                
                                HStack{
                                    Text("Participants:").font(.footnote).foregroundColor(.white)
                                    Image(systemName: "person.fill").foregroundColor(Color("colorBlue"))
                                    Text("Pilot1")
                                        .font(.footnote).foregroundColor(.white)
                                    Image(systemName: "person.fill").foregroundColor(Color("colorBlue"))
                                    Text("Pilot2")
                                    //.onAppear(perform: setup)
                                        .font(.footnote).foregroundColor(.white)
                                }
                            }.padding(.bottom, 5)
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack{
                                
                                Button(action:{ print("CLicked")}){
                                    Image(systemName: "record.circle").foregroundColor(.red).font(.title2)
                                }.padding(.leading, 250).padding(.bottom,10)
                                
                                HStack(spacing: 2) {
                                    TimerCell(timeUnit: 1)
                                    Text(":")
                                    TimerCell(timeUnit: 40)
                                    Text(":")
                                    TimerCell(timeUnit: 20)
                                    
                                }.fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18))
                                    .frame(width: 117, height: 36).background(Color("darkmodeColor1")).cornerRadius(6)
                                    .padding(.bottom,10)
                                //.onAppear{self.instructorVM.triggerTimer()}
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action:{
                            }){
                                Image(systemName: "rectangle.portrait.and.arrow.forward").foregroundColor(.white)
                                Text(" End session")
                            }.frame(width: 156, height: 45)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .background(Color("buttonColorPurple"))
                                .cornerRadius(11)
                                .padding(.bottom, 12)
                                .padding(.trailing, -9)
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
            //            Color("darkmodeColor2").edgesIgnoringSafeArea(.all).zIndex(-1)
        }
        
    }
}

struct testPlayer_Previews: PreviewProvider {
    static var previews: some View {
        testPlayer()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
