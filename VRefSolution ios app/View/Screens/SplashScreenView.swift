//
//  SplashScreenView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 05/12/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.1
    @State private var opacity = 0.1
    
    var body: some View {
        if isActive{
            ContentView()
        }
        else{
            
            
            ZStack{
                //background color
                Color("darkmodeColor2").edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("LoginLogo")
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 1.2
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
