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
    @Published var doneAuthentication: Bool = false
    @Published var error: AuthenticationError?
    @Published var hasError: Bool = false
    private let loginService: LoginService = LoginService()
    private let keychain = Keychain()
    private var accessTokenKeyChainKey = "accessToken"
    private var userIdKeyChainKey = "userId"
    private var companyIdKeyChainKey = "companyId"
    private var userRoleKeyChainKey = "userRole"
    private var expiresAtKeyChainKey = "expirationTime"
    private var firstNameKeyChainKey = "firstName"
    
    var isAuthenticated: Bool {
        if (self.accessToken != nil){
            self.decodeToken()
            
            if (DateParser().toDate(date: self.expiresAt!)! >= Date.now){
                return true
            }
        }
        return false
    }
    
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
    
    var firstName: String? {
        get{
            try? keychain.getString(firstNameKeyChainKey)
        }
        set(newValue){
            guard let firstName = newValue else{
                try? keychain.remove(firstNameKeyChainKey)
                return
            }
            try? keychain.set("\(firstName)", key: firstNameKeyChainKey)
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
    
    var expiresAt: String? {
        get{
            try? keychain.getString(expiresAtKeyChainKey)
        }
        set(newValue){
            guard let expiresAt = newValue else{
                try? keychain.remove(expiresAtKeyChainKey)
                return
            }
            try? keychain.set("\(expiresAt)", key: expiresAtKeyChainKey)
        }
    }
    
    func login() {
        
        loginService.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                print("TOKEN: { \(token) }")
                self.accessToken = token
                self.doneAuthentication = true
                self.firstName = self.username
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
        self.firstName = nil
        DispatchQueue.main.async {
            self.doneAuthentication = false
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
                
                self.userRole = jwt["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"].string
                self.companyId = jwt["CompanyId"].string
                self.userId = jwt["UserId"].string
                self.expiresAt = DateParser().toString(date: jwt.expiresAt!)
   
            }

        } catch {
            print("Failed to decode JWT: \(error)")
        }
    }
}
