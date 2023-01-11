//
//  InstructorView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 24/11/2022.
//

import SwiftUI
import CustomAlert
//import AVKit

struct InstructorView: View {
    
    @StateObject private var instructorVM = InstructorViewModel()

    @State private var selectedEvent: Event?
    @State private var writtenNote: String = ""
    @State private var selectedNote: String = ""
    @State private var noteRating = 0
    
    @State private var showingAlert = false
    @State private var alertShown = false
    @State var emptyEvents : Bool = false
    @State private var linkIsCopied = false
    
    @State private var obsSuccessful = false

    @State private var selectedPilot: PilotType = PilotType.Both
    @State private var selectedNoteOption: NoteOption = .Written
    
    let session: Session
    let video: Video
    let isContinuing: Bool
    
    var body: some View {
        if(instructorVM.readyToStop){
            MainMenuView(selectedSession: self.session)
        }
        else{
            
            ZStack(){
                //Topbar
                NavigationView(){
                    ScrollView(){
                        VStack(){
                    
                            //livestream
                            Group(){
                                
                                if(obsSuccessful && self.instructorVM.liveEvent?.hls != nil){
                                    
                                    PlayerView(videoLink: self.instructorVM.liveEvent!.hls!).onAppear{self.instructorVM.triggerTimer()}
                                    
                                }
                                else{
                                    VStack{
                                        
                                        if (self.instructorVM.liveEvent?.hls != nil && self.instructorVM.streamingAsset?.status == .Running){
                                            Button(action:{
                                                print("clicked start")
                                                self.obsSuccessful = true
                                                self.instructorVM.triggerTimer()
                                            }){
                                                Image(systemName: "livephoto.play").font(.title)
                                                    .foregroundColor(.white)
                                                Text("Start").bold().font(.title)
                                            }.frame(width: 237, height: 55)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                .background(Color("buttonColorPurple"))
                                                .cornerRadius(20.0)
                                                .padding(.bottom, 70)
                                        }
                                        else{
                                            
                                            ProgressView(self.instructorVM.progressLiveStream)
                                                .foregroundColor(Color("colorBlue")).font((.system(size: 8))).bold()
                                                .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                                .scaleEffect(x: 3, y: 3, anchor: .center).padding(.bottom, 90)
                                        }
                                        
                                        Text("Start OBS Studio and use the following ingest url:").fontWeight(.bold)
                                            .foregroundColor(Color.white)
                                        
                                        
                                        HStack{
                                            
                                            Text(self.instructorVM.streamingAsset?.ingestURL == nil ? "link is being retrieved..." : String(self.instructorVM.streamingAsset!.ingestURL)).frame(width: 350, height: 50).background(.white).padding(.leading,70)
                                            
                                            Button(action:{
                                                UIPasteboard.general.string = self.instructorVM.streamingAsset!.ingestURL
                                                
                                                self.linkIsCopied = true
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                                    self.linkIsCopied = false
                                                }
                                                
                                            }){
                                                Image(systemName: "doc.on.doc")
                                                    .foregroundColor(.white)
                                                    .font(.title2)
                                            }.frame(width: 60, height: 50)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color.white)
                                                .background(self.instructorVM.streamingAsset?.ingestURL.isEmpty ?? false ? .gray : .green)
                                                .padding(.leading,-8)
                                                .disabled(self.instructorVM.streamingAsset?.ingestURL.isEmpty ?? true)
                                            
                                            Text("Copied!").foregroundColor(.green).bold().font(.title3).opacity(self.linkIsCopied ? 1 : 0)
                                        }
                                    }
                                }
                                }.frame(width: 888, height: 492).border(.black).position(x:746, y: 248)//.zIndex(3)
               
                            //background color
                            //Color("darkmodeColor2").edgesIgnoringSafeArea(.all)
                            
                            
                        }//.zIndex(-2)
                        .background(Color("darkmodeColor2").frame(height: 2000))
                        //.background(Color("darkmodeColor2").frame(width: 90000, height: 2000))
                        
                        .toolbarBackground(Color("topbarColor"), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading){
                                Image("shortLogo").padding(.bottom,10)
                            }
                            ToolbarItem(placement: .navigationBarLeading){
                                VStack(alignment: .leading){
                                    Text(self.session.sessionName)
                                        .font(.headline).fontWeight(.bold).foregroundColor(Color("buttonColorBlue")).bold().padding(.bottom, -9)
                                    Text(DateParser().parseDate(date: self.session.startTime))
                                        .font(.footnote).foregroundColor(.white).padding(.bottom, -8)
                                    
                                    HStack{
                                        Text("Participants:").font(.footnote).foregroundColor(.white)
                                        Image(systemName: "person.fill").foregroundColor(Color("colorBlue"))
                                        Text(self.session.users?[1].firstName ?? "") //fix
                                            .font(.footnote).foregroundColor(.white)
                                        Image(systemName: "person.fill").foregroundColor(Color("colorBlue"))
                                        Text(self.session.users?[2].firstName ?? "")
                                            .onAppear(perform: setup)
                                            .font(.footnote).foregroundColor(.white)
                                    }
                                }.padding(.bottom, 5)
                            }
                            ToolbarItem(placement: .navigationBarLeading){
                                HStack{
                                    
                                    Button(action:{self.instructorVM.triggerTimer(); print("CLicked")}){
                                        Image(systemName:  !self.instructorVM.isRunning ? "pause.circle" : "record.circle").foregroundColor(.red).font(.title2)
                                    }.padding(.leading, 250).padding(.bottom,10)
                                    
                                    HStack(spacing: 2) {
                                        TimerCell(timeUnit: instructorVM.hours)
                                        Text(":")
                                        TimerCell(timeUnit: instructorVM.minutes)
                                        Text(":")
                                        TimerCell(timeUnit: instructorVM.seconds)
                                        
                                    }.fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                        .frame(width: 117, height: 36).background(Color("darkmodeColor1")).cornerRadius(6)
                                        .padding(.bottom,10)
                                    //.onAppear{self.instructorVM.triggerTimer()}
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing){
                                Button(action:{
                                    self.showingAlert = true
                                }){
                                    Image(systemName: "rectangle.portrait.and.arrow.forward").foregroundColor(.white)
                                    Text(" End session")
                                }.frame(width: 156, height: 45)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .background(Color("buttonColorPurple"))
                                    .cornerRadius(11)
                                    .padding(.bottom, 12)
                                    .padding(.trailing, -9)
                            }
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                //left menu
                Group(){
                    VStack(){
                        
                        Text("All Highlights")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                        ScrollViewReader { value in
                            ScrollView{
                                if(self.instructorVM.eventsOfSession.count > 0){
                                    VStack(spacing: 0){
                                        ForEach(instructorVM.eventsOfSession) { event in
                                            
                                            Button(action: {
                                                self.selectedEvent = event
                                                value.scrollTo(selectedEvent!.id, anchor: .bottom)
                                                updateNote(toPush: false)
                                            }) {
                                                
                                                EventCell(event: event, selected: event.equals(compareTo: selectedEvent) ? true : false)
                                                //.padding(.bottom, -9)
                                                    .id(event.id)
                                            }.onAppear{
                                                if (self.selectedEvent == nil)
                                                {
                                                    selectedEvent = instructorVM.eventsOfSession.last
                                                    
                                                    updateNote(toPush: false)
                                                    
                                                    value.scrollTo(selectedEvent!.id, anchor: .bottom)
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                                else if (emptyEvents){
                                    Text("No events found. Someting went wront")
                                        .multilineTextAlignment(.center).foregroundColor(.white).font((.system(size: 18)))
                                        .frame(width: 200, height: 400, alignment: .center)
                                }
                                else{
                                    VStack{
                                        ProgressView("Loading...")
                                            .foregroundColor(Color("buttonColorBlue")).font((.system(size: 8)))
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                            .scaleEffect(x: 3, y: 3, anchor: .center)
                                            .onAppear{
                                                if (obsSuccessful){
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                                                        emptyEvents = true
                                                    }
                                                }
                                            }
                                    }.frame(width: 200.0, height: 500.0).padding(.top)
                                    //.onAppear(perform: handleOnAppear)
                                }
                                
                            }.frame(maxWidth: .infinity)
                                .frame(height: 540)
                                .background(.gray)
                            //                            .onChange(of: self.selectedEvent!) { value in
                            //                                let note = selectedEvent?.getNote(type: selectedPilot)
                            //
                            //                                self.noteRating = note?.rating ?? 0;
                            //                                self.selectedNoteOption = note?.noteOption ?? .Written;
                            //                                self.writtenNote = note?.note ?? ""}
                        }
                        Button(action:{
                            selectedEvent = instructorVM.markedEvent();
                            updateNote(toPush: false)
                        }){
                            Image(systemName: "doc.text")
                                .foregroundColor(.white)
                            Text(" Marked event")
                        }.frame(width: 237, height: 55)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .background(Color(selectedEvent?.eventType == .MARKED_EVENT  ? "buttonPurpleSelected" : "buttonColorPurple"))
                            .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                            .padding(.top)
                            .disabled(selectedEvent?.eventType == .MARKED_EVENT)
                        
                        
                        
                        
                        Text("Current altitude: \(self.selectedEvent?.altitude ?? 0) ft").padding(.leading,45).frame(width: 275, height: 25, alignment: .leading).background(.gray).padding(.top).padding(.bottom, 18)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                        
                    }.frame(width: 299, height: 761).background(Color("darkmodeColor1")).offset(x: -447.0, y: 36)
                }
                
                //notes
                ZStack(){
                    
                    //left side
                    VStack(alignment: .leading){
                        Text("Add Notes")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, -2)
                        
                        Text("add a note to the event described below")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color("lightGreyText"))
                            .padding(.bottom, 15)
                            .lineLimit(2)
                        
                        HStack(){
                            Text("Event Type: ").font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            HStack{
                                Image(selectedEvent?.eventType.eventIcon ?? "").padding(.leading)
                                Text(selectedEvent?.eventType.eventName ?? "").font(.subheadline)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/).frame(width: 110, alignment: .leading)                            }.frame(width: 120)
                        }
                        
                        HStack(){
                            Text("Altitude: ").font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            Text("\(self.selectedEvent?.altitude ?? 0) ft").font(.subheadline)
                                .foregroundColor(Color("lightGreyText"))
                        }.padding(.bottom,1)
                        HStack(){
                            Text("Timestamp: ").font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            Text(self.selectedEvent != nil ?
                                 DateParser().getCurrentTimerInFormat(progressTime: selectedEvent!.timestamp) : "").font(.subheadline)
                                .foregroundColor(Color("lightGreyText"))
                        }
                        
                    }.frame(width: 250, height: 239).position(x: 125, y: 115)
                    
                    //right side
                    VStack(){
                        HStack(){
                            Button(action:{
                                self.selectedPilot = PilotType.First_Officer
                            }){
                                Text("First Officer")
                                    .multilineTextAlignment(.center)
                                Image("note").opacity(selectedEvent?.feedbackFirstOfficer.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 150, height: 36)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.First_Officer ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.black)
                            
                            Button(action:{self.selectedPilot = PilotType.Both}){
                                Text("Both")
                                    .multilineTextAlignment(.center)
                                Image("note").opacity(selectedEvent?.feedbackAll.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 150, height: 36, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.Both ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.black)
                                .padding(.leading, -7)
                            
                            Button(action:{self.selectedPilot = PilotType.Captain}){
                                Text(" Captain")
                                    .multilineTextAlignment(.center)
                                Image("note").opacity(selectedEvent?.feedbackCaptain.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 150, height: 36,alignment: .center)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.Captain ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.black)
                                .padding(.leading, -7)
                        }.frame(width: 350).position(x:229, y:25).onChange(of: self.selectedPilot) { value in
                            self.updateNote(toPush: false)
                        }
                        
                        VStack{
                            
                            HStack{
                                Text("Note: ").font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                
                                Button(action:{self.selectedNoteOption = NoteOption.Selected}){
                                    Text("Select feedback")
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }.frame(width: 90, height: 45, alignment: .center)
                                    .foregroundColor(Color.white)
                                    .background(selectedNoteOption == NoteOption.Selected ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                    .border(.black)
                                    .padding(.leading, -7)
                                
                                Button(action:{self.selectedNoteOption = NoteOption.Written}){
                                    Text("Write feedback")
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }.frame(width: 90, height: 45, alignment: .center)
                                    .foregroundColor(Color.white)
                                    .background(selectedNoteOption == NoteOption.Written ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                    .border(.black)
                                    .padding(.leading, -7)
                            }.position(x:120, y:40)
                            VStack(alignment: .leading){
                                Text("Rating: ").font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                
                                RatingCell(rating: $noteRating)
                            }.position(x:80, y:30)
                            
                            VStack(){
                                TextField("Write a note for \(self.selectedPilot.rawValue)...", text: $writtenNote)
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                    .frame(width:330, height: 120, alignment: Alignment.topLeading)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .position(x: 450, y: -60)
                                    .opacity(self.selectedNoteOption == .Written ? 1 : 0)
                                Menu {
                                    ForEach(instructorVM.commonFeedback, id: \.self){ cf in
                                        Button(cf) {
                                            self.selectedNote = cf
                                        }
                                    }
                                } label: {
                                    HStack{
                                        Text(selectedNote.isEmpty ? "Select common feedback" : selectedNote)
                                            .foregroundColor(selectedNote.isEmpty ? Color("lightGreyText") : .black)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(Color.gray)
                                            .font(Font.system(size: 20, weight: .bold))
                                    }
                                    .padding(.horizontal)
                                }.frame(width:330, height: 44, alignment: Alignment.center)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .position(x: 450, y: -120)
                                // .offset(y: -1.0)
                                    .opacity(self.selectedNoteOption == .Selected ? 1 : 0)
                                
                                Button(action:{
                                    updateNote(toPush: true)
                                    if(selectedEvent?.eventType == .MARKED_EVENT){
                                        //self.selectedEvent.
                                        instructorVM.createEvent(event: selectedEvent!)
                                    }
                                    else{
                                        if(selectedEvent != nil){
                                            instructorVM.updateEvent(event: selectedEvent!)
                                        }
                                    }
                                    instructorVM.getEvents(logbookId: self.video.logbookId)
                                    updateNote(toPush: false)
                                    
                                }){
                                    Image(systemName: "doc.text")
                                        .foregroundColor(.white)
                                    Text(selectedEvent?.hasNotes ?? false ? "Add note" : "Save changes")
                                }.frame(width: 159, height: 39)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .background(Color(noteRating != 0 || !writtenNote.isEmpty || !selectedNote.isEmpty || selectedEvent != nil ? "buttonColorPurple" : "buttonPurpleSelected"))
                                    .cornerRadius(10)
                                    .position(x:535, y:-13)
                                    .disabled(noteRating == 0 && writtenNote.isEmpty && selectedNote.isEmpty && selectedEvent == nil)
                                    .disabled(selectedEvent == nil)
                                
                            }
                        }.frame(width: 630, height: 190).background(Color("darkmodeColor3")).offset(y:-5)
                    }.frame(width: 640, height: 239).position(x: 570, y: 115)
                }.frame(width: 888, height: 239).background(Color("darkmodeColor2")).position(x:746, y: 670)
            }.alert(isPresented:$showingAlert) {
                Alert(
                    title: Text("Are you sure you want to end this session?"),
                    primaryButton: .default(Text("Confirm")) {
                        print("Confirm clicked")
                        self.alertShown = true
                        self.instructorVM.updateSessionStatus(sessionId: session.id)
                        self.instructorVM.endLiveSession()
                    },
                    secondaryButton: .cancel(){print("Cancel clicked")}
                )
            }.customAlert(isPresented: $alertShown) {
                HStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.blue)
                    Text("Processing...")
                        .font(.headline)
                }
            } actions: {
                Button(role: .cancel) {
                    // Cancel Action
                } label: {
                    Text("Cancel")
                }
                
            }
        }
    }
}

// MARK: Action handlers
private extension InstructorView {
    
    func setup(){
        self.instructorVM.setup(isContinuing: self.isContinuing, currentVideo: self.video)
        
        self.instructorVM.updateLiveStream(liveEvent: LiveEvent(name: .Camera1, stopLive: .Run, hls: nil))
    }
    
    func updateNote(toPush: Bool){
        
        if(self.selectedEvent != nil){
            let note = selectedNote == "" ? writtenNote : selectedNote
            
            if (self.selectedPilot == .First_Officer){
                
                if(toPush){
                    
                    self.selectedEvent?.ratingFirstOfficer = noteRating;
                    self.selectedEvent?.feedbackFirstOfficer = note
                }
                else{
                    self.noteRating = selectedEvent?.ratingFirstOfficer ?? 0;
                    self.writtenNote = selectedEvent?.feedbackFirstOfficer ?? ""
                }
            }
            else if (self.selectedPilot == .Captain){
                if(toPush){
                    self.selectedEvent?.ratingCaptain = noteRating;
                    self.selectedEvent?.feedbackCaptain = note
                }
                else{
                    self.noteRating = selectedEvent?.ratingCaptain ?? 0;
                    self.writtenNote = selectedEvent?.feedbackCaptain ?? ""
                }
            }
            else if (self.selectedPilot == .Both){
                if(toPush){
                    self.selectedEvent?.ratingAll = noteRating;
                    self.selectedEvent?.feedbackAll = note
                }
                else{
                    self.noteRating = selectedEvent?.ratingAll ?? 0;
                    self.writtenNote = selectedEvent?.feedbackAll ?? ""
                }
            }

            self.selectedNoteOption = .Written;
            self.selectedNote = ""
        }
    }
    

//    func handelTimer(){
//        if (!instuctorVM.isRunning){
//            instuctorVM.pauzeTimer()
//        }
//        else{
//            instuctorVM.startTimer()
//        }
//    }
    
//    func handleTimer() {
//
//        if isRunning{
//            timer?.invalidate()
//        } else {
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//                progressTime += 1
//            })
//        }
//        isRunning.toggle()
//    }
}

struct InstructorView_Previews: PreviewProvider {
    static var previews: some View {
        InstructorView(session: Session(id: "1", startTime: Date.now, companyId: "1", videos: [], status: .Started), video: Video(id: "1", videoName: nil, videoURL: nil, timeExpire: Date.now, sessionId: "1", logbookId: "1"),isContinuing: false)
        .previewInterfaceOrientation(.landscapeLeft)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
