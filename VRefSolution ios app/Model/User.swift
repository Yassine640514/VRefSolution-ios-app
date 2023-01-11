//
//  User.swift
//  VRefSolution ios app
//
//  Created by Yassine on 14/12/2022.
//

import Foundation

struct User: Identifiable{
    
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let userName: String
    let role: UserType
    let companyId: String
    
    func equals (compareTo:User) -> Bool {
        return
            self.id == compareTo.id &&
            self.email == compareTo.email &&
            self.firstName == compareTo.firstName &&
            self.lastName == compareTo.lastName &&
            self.userName == compareTo.userName &&
            self.role == compareTo.role &&
            self.companyId == compareTo.companyId
    }
}

enum UserType : String {
    case ROLE_SUPERADMIN, ROLE_ADMIN, ROLE_INSTRUCTOR, ROLE_PILOT
}
