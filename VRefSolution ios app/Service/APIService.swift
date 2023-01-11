//
//  APIService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 27/11/2022.
//

import Foundation
import Combine

class APIService{
    
    private var cancellables: [AnyCancellable] = []
    
    func execute<T: Decodable>(type: T.Type, request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTaskPublisher(for: request)
            .map({ $0.data })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { response in
                    completion(.success(response))
                }
            )
            .store(in: &cancellables)
    }
}

struct BaseURL {
    static let url = "https://vrefsolutionsdev001.azurewebsites.net/api/"
    static let urlMediaService = "https://mediaserviceclient.azurewebsites.net/api/"
}

