//
//  Login.swift
//  VRefSolution ios app
//
//  Created by Yassine on 27/11/2022.
//

import Foundation

struct Login: Decodable{
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case password = "password"
    }
}
