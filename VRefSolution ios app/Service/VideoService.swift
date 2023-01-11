//
//  VideoService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 04/01/2023.
//

import Foundation
import Combine

class VideoService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    private var cancellables: [AnyCancellable] = []
    
    func createVideo(sessionId: String, completion: @escaping (Result<Video, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)PostVideo") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        let video = "https://vrefsolutionsdownload.blob.core.windows.net/trainevids/OVERVIEW.mp4"
        
        let body = VideoCreateRequestBody(videoUrl: video, sessionId: sessionId, videoContainerName: "")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: VideoResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Video(id: response.id, videoName: response.videoContainerName, videoURL: response.videoURL, timeExpire: DateParser().toDate(date: response.timeExpire)!, sessionId: response.sessionId, logbookId: response.logbookId)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func getVideoBySessionId(sessionId: String, completion: @escaping (Result<Video, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)GetVideoBySessionId/\(sessionId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: [VideoResponse].self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Video(id: response[0].id, videoName: response[0].videoContainerName, videoURL: response[0].videoURL, timeExpire: DateParser().toDate(date: response[0].timeExpire)!, sessionId: response[0].sessionId, logbookId: response[0].logbookId)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func updateVideoDetails(videoId: String, videoUrl: String, completion: @escaping (Result<String, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)EditVideoDetails") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = VideoUpdateRequestBody(VideoId: videoId, VideoURL: videoUrl)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
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
