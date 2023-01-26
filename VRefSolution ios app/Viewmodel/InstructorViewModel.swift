//
//  InstructorViewModel.swift
//  VRefSolution ios app
//
//  Created by Yassine on 01/12/2022.
//

import Foundation

class InstructorViewModel: ObservableObject {
    
    /// Serivces
    private let eventService: EventService = EventService()
    private let recordService: RecordService = RecordService()
    private let sessionService: SessionService = SessionService()
    private let streamingService: StreamingService = StreamingService()
    private let videoService: VideoService = VideoService()
    
    /// Timer variables
    @Published private var timer: Timer?
    @Published var timerPauzed: Bool = false
    @Published var progressTime = 0
    @Published var isRunning = false
    
    //current session variables
    @Published var isContinuing: Bool = false
    @Published var currentVideo: Video?
    
    /// event variables
    @Published var eventsOfSession: [Event] = []
    @Published var recordsOfEvents: [Record] = []
    @Published var eventsAvailable = false
    @Published var nextId: Int = 0
    private let repeatInterval = 10
    private var maxEvents = 15
    private var lastAltitude = 0
    private let updateAltitudeWith = 2500
    
    /// popup variable
    @Published var readyToStop: Bool = false
    
    //livestream
    @Published var liveEvent: LiveEvent?
    @Published var streamingAsset: StreamingAsset?
    @Published var obsSuccessful = false
    @Published var progressLiveStream = " Livestream is going to start soon..."
    
    /// Computed properties to get the progressTime in hh:mm:ss format
    var hours: Int {
        progressTime / 3600
    }
    
    var minutes: Int {
        (progressTime % 3600) / 60
    }
    
    var seconds: Int {
        progressTime % 60
    }
    
    var generatedAltitude: Int {
        
        var tempMinAltitude: Int
        var tempMaxAltitude: Int
        
        // generate lower altitude in the end
        if (self.eventsOfSession.count < maxEvents / 2){
            tempMinAltitude = self.lastAltitude
            tempMaxAltitude = self.lastAltitude + self.updateAltitudeWith
        }
        else{
            tempMinAltitude = self.lastAltitude - self.updateAltitudeWith / 2
            tempMaxAltitude = self.lastAltitude
        }
        let alt = Int.random(in: tempMinAltitude...tempMaxAltitude)
        self.lastAltitude = alt
        return alt
    }
    
    var commonFeedback: [String] {
        return ["High speed", "Altitude too high", "Altitude too low"]
    }
    
    ///functions
    func setup(isContinuing: Bool, currentVideo: Video) {
        
        self.isContinuing = isContinuing
        self.currentVideo = currentVideo
        
        if(isContinuing){
            //continue where left off
            getEvents(logbookId: currentVideo.logbookId)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                if(self.eventsAvailable && self.eventsOfSession.count > 0){
                    
                    //update variables
                    self.progressTime = self.eventsOfSession.last!.timestamp
                    self.nextId = self.eventsOfSession.count
                    
                    ////THIS CODE BELOW IS FOR THE LIVESTREAM
                    //self.updateLiveStream(liveEvent: LiveEvent(name: .Camera1, stopLive: .Run, hls: nil))
                }
            }
        }
    }
    
    func triggerTimer()
    {
        if(self.currentVideo != nil){
            
            if isRunning{
                timer?.invalidate()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.progressTime += 1
                    
                    //first event is take off
                    if (self.nextId == 0) {
                        self.createEvent(event: Event(eventId: nil, logbookId: self.currentVideo!.logbookId, timestamp: self.progressTime, eventType: eventType.TAKE_OFF, captain: nil, firstOfficer: nil, feedbackAll: nil, feedbackCaptain: nil, feedbackFirstOfficer: nil, ratingAll: nil, ratingCaptain: nil, ratingFirstOfficer: nil, altitude: self.generatedAltitude))
                        
                        self.nextId += 1
                    }
                    
                    //every 10 sec add event to array
                    else if self.progressTime % self.repeatInterval == 0 {
                        self.triggerRandomEvent()
                    }
                })
            }
            isRunning.toggle()
        }
    }
    
    func triggerRandomEvent(){
        
        if (self.nextId <= maxEvents){
            self.createEvent(event: Event(eventId: nil, logbookId: self.currentVideo!.logbookId, timestamp: self.progressTime, eventType: self.nextId == maxEvents ? eventType.LANDING : eventType.random(), captain: nil, firstOfficer: nil, feedbackAll: nil, feedbackCaptain: nil, feedbackFirstOfficer: nil, ratingAll: nil, ratingCaptain: nil, ratingFirstOfficer: nil, altitude: self.generatedAltitude))
            
            self.nextId += 1
        }
    }
    
    func markedEvent() -> Event{
        
        let event = Event(eventId: nil, logbookId: self.currentVideo!.logbookId, timestamp: self.progressTime, eventType: eventType.MARKED_EVENT, captain: nil, firstOfficer: nil, feedbackAll: nil, feedbackCaptain: nil, feedbackFirstOfficer: nil, ratingAll: nil, ratingCaptain: nil, ratingFirstOfficer: nil, altitude: self.lastAltitude)
        
        self.nextId += 1
        self.maxEvents += 1
        
        return event
    }
    
    func getEvents(logbookId: String){
        
        self.eventService.getEventsByLogbookId(logbookId: logbookId){ result in
            switch result {
            case .success(let result):
                self.eventsOfSession = result
                self.getRecords(logbookId: logbookId)
                print("events from api: { \(result) }")
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    private func linkRecords(){
        
        self.recordsOfEvents.forEach{ record in
            
            if let i = self.eventsOfSession.firstIndex(where: {$0.timestamp == record.timeStamp}) {
                
                // updating altitude
                if(self.eventsOfSession[i].altitude == nil){
                    self.eventsOfSession[i].altitude = record.altitude
                }
                
            }
        }
    }
    
    func getRecords(logbookId: String){
        
        self.recordService.getRecordsByLogbookId(logbookId: logbookId){ result in
            switch result {
            case .success(let result):
                self.recordsOfEvents = result
                self.linkRecords()
                self.eventsAvailable = true
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func createEvent(event: Event){
        
        self.eventService.createEvent(event: event){ result in
            switch result {
            case .success(let result):
                print("created event: { \(result) }")
                self.createRecord(record: Record(timeStamp: event.timestamp, altitude: event.altitude!, logbookId: event.logbookId!))
                self.getEvents(logbookId: result.logbookId!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createRecord(record: Record){
        
        self.recordService.createRecord(record: record){ result in
            switch result {
            case .success(let result):
                print("created record for event: { \(result) }")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateEvent(event: Event){
        
        self.eventService.updateEventByEventId(event: event){ result in
            switch result {
            case .success(let result):
                if let i = self.eventsOfSession.firstIndex(where: { $0.id == event.id}) {
                    self.eventsOfSession[i] = result
                    print("updated event: { \(result) }")
                    self.getEvents(logbookId: result.logbookId!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateSessionStatus(sessionId: String){
        
        self.sessionService.updateSessionStatusBySessionId(sessioId: sessionId){ result in
            switch result {
            case .success(_):
                self.readyToStop = true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateCurrentVideoUrl(videoUrl: String){
        
        self.videoService.updateVideoDetails(videoId: self.currentVideo!.id, videoUrl: videoUrl){ result in
            switch result {
            case .success(_):
                self.currentVideo!.videoURL = videoUrl
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func endLiveSession(){
        self.updateLiveStream(liveEvent: LiveEvent(name: self.liveEvent!.name , stopLive: .Stop, hls: self.liveEvent?.hls))
        self.streamingAsset = nil
        self.liveEvent = nil
    }
    
    func updateLiveStream(liveEvent: LiveEvent){
        
        self.streamingService.updateLiveEvents(liveEvent: liveEvent){ result in
            switch result {
            case .success(let result):
                self.liveEvent = result
                self.updateCurrentVideoUrl(videoUrl: result.hls!)
                self.checkStreamingEndpoint()
                print("SUCCESFULLY updated livestream \(result)")
                print("HLS IS { \(result.hls!) }")
                self.progressLiveStream = "Starting the livestream..."
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkStreamingEndpoint(){
        
        self.streamingService.getStreamingAssets(streamingCamera: self.liveEvent!.name ){ result in
            switch result {
            case .success(let result):
                self.streamingAsset = result
                print("SUCCESFULLY checked livestream \(result)")
                //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.progressLiveStream = "Checking livestream status..."
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
