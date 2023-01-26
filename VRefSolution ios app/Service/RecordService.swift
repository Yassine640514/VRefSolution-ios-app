//
//  RecordService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 10/01/2023.
//

import Foundation
import Combine

class RecordService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    
    func getRecordsByLogbookId(logbookId: String, completion: @escaping (Result<[Record], ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)Records/get-by-logbook/\(logbookId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: [RecordResponse].self, request: request, completion: { result in
            switch result{
            case .success(let response):
                
                let result = response.map({entity in
                    return Record(id: entity.id, timeStamp: entity.timeStamp, altitude: entity.altitude, logbookId: entity.logbookId)
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func createRecord(record: Record, completion: @escaping (Result<Record, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)Records/create") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = RecordCreateRequestBody(timeStamp: record.timeStamp, altitude: record.altitude, logbookId: record.logbookId)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: RecordResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Record(id: response.id, timeStamp: response.timeStamp, altitude: response.altitude, logbookId: response.logbookId)
        
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
}
