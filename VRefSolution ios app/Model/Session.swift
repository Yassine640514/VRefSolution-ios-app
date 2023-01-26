//
//  Session.swift
//  VRefSolution ios app
//
//  Created by Yassine on 12/12/2022.
//

import Foundation

struct Session: Identifiable{
    
    let id: String
    let startTime: Date
    let companyId: String
    let videos: [String]?
    var users: [User]?
    let status: SessionStatus?

    // A computed property to generate a session name.
    var sessionName: String {
        return DateParser().getSessionName(date: self.startTime)
    }
    
    func equals (compareTo:Session?) -> Bool {
        if (compareTo == nil){
            return false
        }
        else{
            return
                self.id == compareTo!.id &&
                self.startTime == compareTo!.startTime &&
                self.companyId == compareTo!.companyId &&
                self.videos == compareTo!.videos &&
//            self.users == compareTo!.users &&
                self.status == compareTo!.status
        }
    }
}

enum SessionStatus : String {
    case Started = "STARTED"
    case Finished = "FINISHED"
}
