//
//  Event.swift
//  VRefSolution ios app
//
//  Created by Yassine on 30/11/2022.
//

import Foundation

struct Event: Identifiable{
    
    var id: Int {
            self.timestamp
        }
    let eventId: String?
    let logbookId: String?
    let timestamp: Int
    let eventType: eventType
    var captain: String?
    var firstOfficer: String?
    var feedbackAll: String?
    var feedbackCaptain: String?
    var feedbackFirstOfficer: String?
    var ratingAll: Int?
    var ratingCaptain: Int?
    var ratingFirstOfficer: Int?
    var altitude: Int?

    private func isObjectNotNil(object:AnyObject!) -> Bool
    {
        if let _:AnyObject = object
        {
            return true
        }

        return false
    }
    
    // A computed property
    var hasNotes: Bool {
        
        return feedbackAll.isEmptyOrNil && feedbackCaptain.isEmptyOrNil && feedbackFirstOfficer.isEmptyOrNil
    }
    
    func equals (compareTo:Event?) -> Bool {
        if (compareTo == nil){
            return false
        }
        else{
            return
                self.id == compareTo!.id &&
                self.eventType == compareTo!.eventType &&
                self.timestamp == compareTo!.timestamp &&
                self.logbookId == compareTo!.logbookId &&
                self.eventId == compareTo!.eventId
        }
    }
}

enum eventType: String {
    case MARKED_EVENT
    case MASTER_WARNING
    case ENGINE_FAILURE
    case ENGINE_FIRE
    case TCAS
    case MASTER_CAUTION
    case TAKE_OFF
    case LANDING
    
    static func random() -> eventType {
        let eventsToGetRandomly = [eventType.MASTER_WARNING, .ENGINE_FAILURE, .ENGINE_FIRE, .TCAS, .MASTER_CAUTION]
        let index = Int(arc4random_uniform(UInt32(eventsToGetRandomly.count)))
        let event = eventsToGetRandomly[index].rawValue
        return eventType(rawValue: event)!
    }
    
    var eventTypeColor: String{
        switch self{
        case .MARKED_EVENT:
            return "eventPurple"
        case .MASTER_WARNING:
            return "eventRed"
        case .ENGINE_FAILURE:
            return "eventOrange"
        case .ENGINE_FIRE:
            return "eventRed"
        case .TCAS:
            return "eventRed"
        case .MASTER_CAUTION:
            return "eventYellow"
        case .TAKE_OFF:
            return "eventBlue"
        case .LANDING:
            return "eventBlue"
        }
    }
    
    var eventIcon: String{
        switch self{
        case .MARKED_EVENT:
            return "markedEvent"
        case .MASTER_WARNING:
            return "masterWarning"
        case .ENGINE_FAILURE:
            return "engineFailure"
        case .ENGINE_FIRE:
            return "engineFire"
        case .TCAS:
            return "tcas"
        case .MASTER_CAUTION:
            return "masterCaution"
        case .TAKE_OFF:
            return "takeOff"
        case .LANDING:
            return "landing"
        }
    }
    
    var eventName: String{
        switch self{
        case .MARKED_EVENT:
            return "Marked event"
        case .MASTER_WARNING:
            return "Master warning"
        case .ENGINE_FAILURE:
            return "Engine failure"
        case .ENGINE_FIRE:
            return "Engine fire"
        case .TCAS:
            return "TCAS"
        case .MASTER_CAUTION:
            return "Master caution"
        case .TAKE_OFF:
            return "Take off"
        case .LANDING:
            return "Landing"
        }
    }
}

extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }

}
