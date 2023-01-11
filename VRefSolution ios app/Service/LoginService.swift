//
//  LoginService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 27/11/2022.
//

import Foundation
import Combine

class LoginService{
    
    private let apiService = APIService()
    
    
    func login(username: String, password: String, completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)LoginUser") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = LoginRequestBody(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        
        apiService.execute(type: LoginResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                completion(.success(response.token!))
            case .failure(_):
                completion(.failure(.invalidCredentials))
            }
        })
    }
}
