//
//  NoConnectionView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 05/12/2022.
//

import SwiftUI

struct NoConnectionView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        ZStack(){
            
            //Topbar
            NavigationView(){
                VStack(){
                    //background color
                    Color("darkmodeColor2").edgesIgnoringSafeArea(.all)
                }
                .toolbarBackground(Color("topbarColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Image("shortLogo").padding(.bottom)
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        Text("VRef Solutions")
                            .foregroundColor(Color("buttonColorBlue"))
                            .fontWeight(.bold)
                            .font(.system(size: 25)).frame(width: 200)
                            .padding(.bottom)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Text("About").foregroundColor(Color("buttonColorBlue"))
                            .fontWeight(.bold)
                            .underline()
                            .font(.system(size: 18)).frame(width: 200)
                            .padding(.bottom)
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Text("Contact").foregroundColor(Color("buttonColorBlue"))
                            .fontWeight(.bold)
                            .underline()
                            .font(.system(size: 18))
                            .padding(.bottom)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            Group{
                VStack {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.white)
                    
                    Text("It looks like you're not connected to the internet. Make sure WiFi is enabled and try again")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if !networkManager.isConnected {
                        Button {
                            print("Trying to check internet connection")
                        } label: {
                            Text("Retry")
                                .padding()
                                .font(.headline)
                                .foregroundColor(Color(.systemBlue))
                        }
                        .frame(width: 140)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .padding()
                    }
                }
            }
        }
        
    }
}

struct NoConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoConnectionView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
