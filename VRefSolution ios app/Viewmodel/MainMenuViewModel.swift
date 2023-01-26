//
//  MainMenuViewModel.swift
//  VRefSolution ios app
//
//  Created by Yassine on 30/11/2022.
//

import Foundation

class MainMenuViewModel: ObservableObject {
    
    private let mainMenuService: MainMenuService = MainMenuService()
    private let sessionService: SessionService = SessionService()

    private let videoService: VideoService = VideoService()
    
    @Published var video: Video?

    @Published var readyToStart: Bool = false
    @Published var readyToReview: Bool = false
    
    @Published var isCreated: Bool = false
    @Published var readyToContinue: Bool = false
    
    @Published var sessionsOfLoggedInUser: [Session] = []
    @Published var allUsersOfCompany: [User] = []
    
    @Published var currentSession: Session?
    
    @Published var firstOfficer: User?
    @Published var captain: User?
    var sessionDate: Date?
    var sessionName: String?
    
    func getSessions() {
        
        mainMenuService.getSessionsByLoggedInUser() { result in
            switch result {
            case .success(var result):
                result = result.sorted(by: { $0.startTime > $1.startTime })
                self.sessionsOfLoggedInUser = result
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func getUsers() {
        
        mainMenuService.getUsersByCompanyId() { result in
            switch result {
            case .success(let result):
                self.allUsersOfCompany = result
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setSessionDateAndName(){
        sessionDate = Date()
        sessionName = DateParser().getSessionName(date: sessionDate!)
    }
    
    func createVideo(sessionId: String){
        
        self.videoService.createVideo(sessionId: sessionId) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.video = result
                    print("Created Video: { \(result) }")
                    self.isCreated = true
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getVideo(sessionId: String){
        
        self.videoService.getVideoBySessionId(sessionId: sessionId) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.video = result
                    print("Video from api: { \(result) }")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func createSession(instructor: User){
        
        self.sessionService.createSession(userIds: [instructor.id, self.firstOfficer!.id, self.captain!.id]) { result in
            switch result {
            case .success(var result):
                print("binnen, check result")
                DispatchQueue.main.async {
                    result.users = [instructor, self.firstOfficer!, self.captain!]
                    self.currentSession = result
                    print("Created session: { \(result) }")
                    self.createVideo(sessionId: result.id)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func getUsersBySessionId(session: Session){
        
        mainMenuService.getUsersBySessionId(sessionId: session.id) { result in
            switch result {
            case .success(let result):
                
                if let i = self.sessionsOfLoggedInUser.firstIndex(where: { $0.id == session.id}) {
                    self.sessionsOfLoggedInUser[i].users = result
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPilots() -> [User]{
        // empty array
        var pilots: [User] = []
        
        allUsersOfCompany.forEach{ user in
            if(user.role == UserType.ROLE_PILOT){
                pilots.append(user)
            }
        }
        
        return pilots
    }
    
    func getSessionOfLastDayByRole(role: UserType) -> [Session] {

        let timeToLive: TimeInterval = 60 * 60 * 24 // 60 seconds * 60 minutes * 24 hours
        
        var filtered = self.sessionsOfLoggedInUser.filter { $0.startTime.addingTimeInterval(timeToLive) >= Date.now}
        
        if role == .ROLE_PILOT{
            filtered = self.sessionsOfLoggedInUser.filter{$0.status == .Finished}
        }
        
        return filtered
        
    }
}
