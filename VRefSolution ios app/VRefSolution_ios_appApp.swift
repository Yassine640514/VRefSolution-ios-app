//
//  VRefSolution_ios_appApp.swift
//  VRefSolution ios app
//
//  Created by Yassine on 16/11/2022.
//

import SwiftUI

@main
struct VRefSolution_ios_appApp: App {
    
   @StateObject var loginVm = LoginViewModel()
   @StateObject var networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            if networkManager.isConnected {
                SplashScreenView().environmentObject(loginVm)
                    .environmentObject(networkManager)
            }
            else{
                NoConnectionView().environmentObject(loginVm)
                    .environmentObject(networkManager)
            }
            
        }
    }
}
