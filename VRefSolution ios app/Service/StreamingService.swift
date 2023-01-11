//
//  StreamingService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 06/01/2023.
//

import Foundation
import Combine

class StreamingService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    
    func updateLiveEvents(liveEvent: LiveEvent, completion: @escaping (Result<LiveEvent, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.urlMediaService)UpdateLiveEvents") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = StreamingRequestBody(LiveEventName: liveEvent.name.rawValue, StopLiveBool: liveEvent.stopLive!.rawValue, NewAssetName: liveEvent.assetName)
        

        var request = URLRequest(url: url,timeoutInterval: 60000)
        request.httpMethod = "POST"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: StreamingResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = LiveEvent(name: StreamingCameras(rawValue: response.LiveEventName)! ,stopLive: nil, hls: response.HLS)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func getStreamingAssets(streamingCamera: StreamingCameras, completion: @escaping (Result<StreamingAsset, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.urlMediaService)ListStreamingEndpoints") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 60000)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: [StreamingAssetsResponse].self, request: request, completion: { result in
            switch result{
            case .success(let response):
                if let i = response.firstIndex(where: { $0.StreamName == streamingCamera.rawValue}) {
                    let result = StreamingAsset(name: StreamingCameras(rawValue: response[i].StreamName)!, description: response[i].Description, status: StreamingStatus(rawValue: response[i].StreamStatus)!, ingestURL: response[i].IngestURL, previewURL: response[i].PreviewURL)
                    
                    completion(.success(result))
                }

            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    
}
