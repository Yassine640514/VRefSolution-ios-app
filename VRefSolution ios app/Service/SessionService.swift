//
//  SessionService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 01/01/2023.
//

import Foundation
import Combine

class SessionService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    private var cancellables: [AnyCancellable] = []
    
    func createSession(userIds: [String], completion: @escaping (Result<Session, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)CreateSession") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = SessionCreateRequestBody(UserIds: userIds, CompanyId: loginVM.companyId!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: SessionCreateResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Session(id: response.id, startTime: DateParser().toDate(date: response.startTime)!, companyId: response.companyId, videos: response.videos, users: [], status: SessionStatus(rawValue: response.status ?? ""))
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func updateSessionStatusBySessionId(sessioId: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)UpdateSessionStatusById/\(sessioId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { result in
                        switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            completion(.failure(.custom(errorMessage: error.localizedDescription)))
                        }
                    },
                    receiveValue: { response in
                        completion(.success(""))
                    }
                )
                .store(in: &cancellables)
        }
    }
