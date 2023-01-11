//
//  Note.swift
//  VRefSolution ios app
//
//  Created by Yassine on 30/11/2022.
//

import Foundation

struct Note: Equatable{
    
    let userId: String?
    let note: String?
    let noteOption: NoteOption?
    let rating: Int?
    
    
    func hasNilField() -> Bool {
        
//        if(([userId, note, noteOption, rating] as [Any?]).contains(where: { $0 == nil})){
//            if(note == "" || rating == 0){
//                return true
//            }
//            else{
//                return false
//            }
//        }
//        else{
//            return false
//        }
            //return ([note, rating] as [Any?]).contains(where: { $0 == nil})
        
        if(note == nil)
        {
            return true
        }
        else if(rating == nil)
        {
           return true
        }
        else{
          return false
        }
        }
    
    // A computed property
    var isEmpty: Bool {
        
//        if(note != nil || note != ""){
//            if(rating != nil || rating != 0){
//                return true
//            }
//            return false
//        }
//        else{
//            return false
//        }
        return note == nil && noteOption == nil && rating == nil || rating == 0 || note == ""
        
        //fix
    }
    
}

enum PilotType : String {
    case Captain, First_Officer, Both
}

enum NoteOption : String {
    case Written, Selected
}
