//
//  MainMenuService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 12/12/2022.
//

import Foundation
import Combine

class MainMenuService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    
    func getSessionsByLoggedInUser(completion: @escaping (Result<[Session], ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)GetSessionByUserId/\(loginVM.userId!)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: [SessionResponse].self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = response.map({entity in
                    return Session(id: entity.id, startTime: DateParser().toDate(date: entity.startTime)!, companyId: entity.companyId, videos: entity.videos, users: [], status: SessionStatus(rawValue: entity.status ?? "" ))
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func getUsersByCompanyId(completion: @escaping (Result<[User], ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)GetUserByCompanyID/\(loginVM.companyId!)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: UserResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = response.results.map({entity in
                    return User(id: entity.id, email: entity.email, firstName: entity.firstname, lastName: entity.lastname, userName: entity.username, role: UserType(rawValue: entity.role)!, companyId: entity.companyId)
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func getUsersBySessionId(sessionId: String, completion: @escaping (Result<[User], ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)GetUserBySessionId/\(sessionId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: UserResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = response.results.map({entity in
                    return User(id: entity.id, email: entity.email, firstName: entity.firstname, lastName: entity.lastname, userName: entity.username, role: UserType(rawValue: entity.role)!, companyId: entity.companyId)
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
}
