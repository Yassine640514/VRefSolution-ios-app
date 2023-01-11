//
//  LoginViewModel.swift
//  VRefSolution ios app
//
//  Created by Yassine on 25/11/2022.
//


import Foundation
import KeychainAccess
import JWTDecode

class LoginViewModel: ObservableObject {
    
    var username: String = ""
    var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var error: AuthenticationError?
    @Published var hasError: Bool = false
    private let loginService: LoginService = LoginService()
    private let keychain = Keychain()
    private var accessTokenKeyChainKey = "accessToken"
    private var userIdKeyChainKey = "userId"
    private var companyIdKeyChainKey = "companyId"
    private var userRoleKeyChainKey = "userRole"
    //private let defaults = UserDefaults.standard
    
    var accessToken: String? {
        get {
            try? keychain.getString(accessTokenKeyChainKey)
        }
        set(newValue) {
            guard let accessToken = newValue else {
                try? keychain.remove(accessTokenKeyChainKey)
                return
            }
            try? keychain.set(accessToken, key: accessTokenKeyChainKey)
        }
    }
    
    var userId: String? {
        get{
            try? keychain.getString(userIdKeyChainKey)
        }
        set(newValue){
            guard let userId = newValue else{
                try? keychain.remove(userIdKeyChainKey)
                return
            }
            try? keychain.set("\(userId)", key: userIdKeyChainKey)
        }
    }
    
    var companyId: String? {
        get{
            try? keychain.getString(companyIdKeyChainKey)
        }
        set(newValue){
            guard let companyId = newValue else{
                try? keychain.remove(companyIdKeyChainKey)
                return
            }
            try? keychain.set("\(companyId)", key: companyIdKeyChainKey)
        }
    }
    
    var userRole: String? {
        get{
            try? keychain.getString(userRoleKeyChainKey)
        }
        set(newValue){
            guard let userRole = newValue else{
                try? keychain.remove(userRoleKeyChainKey)
                return
            }
            try? keychain.set("\(userRole)", key: userRoleKeyChainKey)
        }
    }
    
    func login() {
        
        loginService.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                print("TOKENNN: { \(token) }")
                self.accessToken = token
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                self.decodeToken()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error
                }
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        
        self.accessToken = nil
        self.userId = nil
        self.companyId = nil
        self.userRole = nil
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.hasError = false
            self.error = nil
            self.username = ""
            self.password = ""
        }
    }
    
    private func decodeToken(){
        
        do{
            if(self.accessToken != nil)
            {
                let jwt = try decode(jwt: self.accessToken!)
                
                //Role of loggedin person
                self.userRole = jwt["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"].string
                print("Role is \(String(describing: self.userRole))")
                
                self.companyId = jwt["CompanyId"].string
                print("CompanyId is \(String(describing: self.companyId))")
                
                
                self.userId = jwt["UserId"].string
                print("UserId is \(self.userId!)")
                
                
//                defaults.set(jwt.expiresAt, forKey: "expirationTime")
//                print("expirationTime at is \(String(describing: defaults.object(forKey: "expirationTime")))")
//
//                defaults.set(jwt.issuedAt, forKey: "issuedAt")
//                print("issuedAt at is \(String(describing: defaults.object(forKey: "issuedAt")))")
                
            }

        } catch {
            print("Failed to decode JWT: \(error)")
        }
    }
}
