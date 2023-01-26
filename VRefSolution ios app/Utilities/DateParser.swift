//
//  DateParser.swift
//  VRefSolution ios app
//
//  Created by Yassine on 28/12/2022.
//

import Foundation

class DateParser{
    
    func getSessionName(date: Date) -> String{
        
        // mon
        let dateFormat1 = DateFormatter()
        dateFormat1.dateFormat = "E"
        let dayName = dateFormat1.string(from: date)
        
        // 20th
        let dateFormat2 = DateFormatter()
        dateFormat2.dateFormat = "dd"
        let numDay = dateFormat2.string(from: date)
        
        // 12:00
        let dateFormat3 = DateFormatter()
        dateFormat3.dateFormat = "HH:mm"
        let time = dateFormat3.string(from: date)
        
        return "Session - \(dayName) \(numDay)th - \(time)"
        
    }
    
    func parseDate(date: Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date Format
        dateFormatter.dateFormat = "d-M-y - HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    
    func toDate(date: String) -> Date?{
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: date)
        return date
    }
    
    func toString(date: Date) ->String{
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }
    
    func getCurrentTimerInFormat(progressTime: Int) -> String{

        var hours: Int { progressTime / 3600 }
        var minutes: Int { (progressTime % 3600) / 60 }
        var seconds: Int { progressTime % 60 }
        
        return "\(hours < 10 ? "0\(hours)" : String(hours)):\(minutes < 10 ? "0\(minutes)" : String(minutes)):\(seconds < 10 ? "0\(seconds)" : String(seconds))"
    }
}
