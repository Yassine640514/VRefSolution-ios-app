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
    
    // A computed property
    var isEmpty: Bool {
        return note == nil && noteOption == nil && rating == nil || rating == 0 || note == ""
    }
    
    func hasNilField() -> Bool {
        
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
}

enum PilotType : String {
    case Captain, First_Officer, Both
}

enum NoteOption : String {
    case Written, Selected
}
