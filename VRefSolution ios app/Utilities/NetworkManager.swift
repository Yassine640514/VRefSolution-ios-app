//
//  NetworkManager.swift
//  VRefSolution ios app
//
//  Created by Yassine on 05/12/2022.
//

import Foundation
import Network

class NetworkManager: ObservableObject{
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    
    var connectionDescription: String {
        if isConnected {
            return "Internet connection looks good!"
        } else {
            return "It looks like you're not connected to the internet. Make sure WiFi is enabled and try again"
        }
    }
    
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: queue)
    }
}

