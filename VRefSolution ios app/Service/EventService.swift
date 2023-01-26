//
//  EventService.swift
//  VRefSolution ios app
//
//  Created by Yassine on 04/01/2023.
//

import Foundation
import Combine

class EventService{
    
    private let apiService = APIService()
    private let loginVM = LoginViewModel()
    
    func getEventsByLogbookId(logbookId: String, completion: @escaping (Result<[Event], ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)Events/get-by-logbook/\(logbookId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        apiService.execute(type: [EventResponse].self, request: request, completion: { result in
            switch result{
            case .success(let response):
                
                let result = response.map({entity in
                    return Event(eventId: entity.id, logbookId: entity.logbookId, timestamp: entity.timeStamp, eventType: eventType(rawValue: entity.eventType)!, captain: entity.captain, firstOfficer: entity.firstOfficer, feedbackAll: entity.feedbackAll, feedbackCaptain: entity.feedbackCaptain, feedbackFirstOfficer: entity.feedbackFirstOfficer, ratingAll: entity.ratingAll, ratingCaptain: entity.ratingCaptain, ratingFirstOfficer: entity.ratingFirstOfficer)
                })
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func createEvent(event: Event, completion: @escaping (Result<Event, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)Events/create") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        
        let body = EventCreateRequestBody(timeStamp: event.timestamp, eventType: event.eventType.rawValue, logbookId: event.logbookId!, captain: event.captain ?? nil, firstOfficer: event.firstOfficer ?? nil, feedbackAll: event.feedbackAll ?? nil, feedbackCaptain: event.feedbackCaptain ?? nil, feedbackFirstOfficer: event.feedbackFirstOfficer ?? nil, ratingAll: event.ratingAll ?? nil, ratingCaptain: event.ratingCaptain ?? nil, ratingFirstOfficer: event.ratingFirstOfficer ?? nil)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: EventResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Event(eventId: response.id, logbookId: response.logbookId, timestamp: response.timeStamp, eventType: eventType(rawValue: response.eventType)!, captain: response.captain, firstOfficer: response.firstOfficer, feedbackAll: response.feedbackAll, feedbackCaptain: response.feedbackCaptain, feedbackFirstOfficer: response.feedbackFirstOfficer, ratingAll: response.ratingAll, ratingCaptain: response.ratingCaptain, ratingFirstOfficer: response.ratingFirstOfficer)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
    
    func updateEventByEventId(event: Event, completion: @escaping (Result<Event, ApiError>) -> Void) {
        
        guard let url = URL(string: "\(BaseURL.url)Events/update-single/\(event.eventId!)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body = EventUpdateRequestBody(feedbackAll: event.feedbackAll ?? nil, feedbackCaptain: event.feedbackCaptain ?? nil, feedbackFirstOfficer: event.feedbackFirstOfficer ?? nil, ratingAll: event.ratingAll ?? 0, ratingCaptain: event.ratingCaptain ?? 0, ratingFirstOfficer: event.ratingFirstOfficer ?? 0)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(loginVM.accessToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        apiService.execute(type: EventResponse.self, request: request, completion: { result in
            switch result{
            case .success(let response):
                let result = Event(eventId: response.id, logbookId: response.logbookId, timestamp: response.timeStamp, eventType: eventType(rawValue: response.eventType)!, captain: response.captain, firstOfficer: response.firstOfficer, feedbackAll: response.feedbackAll, feedbackCaptain: response.feedbackCaptain, feedbackFirstOfficer: response.feedbackFirstOfficer, ratingAll: response.ratingAll, ratingCaptain: response.ratingCaptain, ratingFirstOfficer: response.ratingFirstOfficer)
                
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        })
    }
}
