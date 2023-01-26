//
//  ContentView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 16/11/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        
        //checking internet connectivity
        if networkManager.isConnected {
            
            if (loginVM.isAuthenticated){
                MainMenuView()
            }
            else{
                LoginView()
            }
            
        }
        else{
            NoConnectionView()
        }
    }
}
        
        

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
