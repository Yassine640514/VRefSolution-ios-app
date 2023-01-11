//
//  ContentView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 16/11/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var loginVM: LoginViewModel
    //let userDefaults = UserDefaults.standard
    
    var body: some View {
        
        //checking internet connectivity
        //if networkManager.isConnected {
            if loginVM.isAuthenticated && loginVM.error == nil{
                MainMenuView()
            }
            else{
                LoginView()
            }
//        }
//        else{
//            NoConnectionView(networkManager: self.networkManager)
//        }
    }
}
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
