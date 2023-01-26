//
//  ReviewView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 06/01/2023.
//

import SwiftUI

struct ReviewView: View {
    @StateObject private var instructorVM = InstructorViewModel()
    private let loginVM = LoginViewModel()
    
    @State private var readyToReturn: Bool = false
    @State private var selectedEvent: Event?
    @State private var writtenNote: String = ""
    @State private var noteRating = 0
    @State private var emptyEvents : Bool = false
    @State private var canChangeNote = false
    @State private var changedNote = false
    @State private var successMessage = false
    
    private var isStudent: Bool {loginVM.userRole! == UserType.ROLE_PILOT.rawValue}
    @State private var selectedPilot: PilotType = PilotType.Both
    
    let session: Session
    let video: Video
    
    var body: some View {
        if(readyToReturn){
            MainMenuView(selectedSession: self.session)
        }
        else{
            ZStack(){
                //Topbar
                NavigationView(){
                    VStack(){
                        //video
                        Group(){
                            
                            if(self.video.videoURL == nil){
                                ProgressView(self.instructorVM.progressLiveStream)
                                    .foregroundColor(Color("colorBlue")).font((.system(size: 8))).bold()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                    .scaleEffect(x: 3, y: 3, anchor: .center).padding(.bottom, 90)
                            }
                            else{
                                PlayerView(videoLink: self.video.videoURL!)
                            }
                        }.frame(width: 888, height: 492).border(.black).position(x:746, y: 248)
                    }
                    .background(Color("darkmodeColor2").frame(height: 2000))
                    .toolbarBackground(Color("topbarColor"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Image("shortLogo").padding(.bottom,10)
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            VStack(alignment: .leading){
                                Text(self.session.sessionName)
                                    .font(.headline).fontWeight(.bold).foregroundColor(Color("reviewPurple")).bold().padding(.bottom, -9)
                                Text(DateParser().parseDate(date: self.session.startTime))
                                    .font(.footnote).foregroundColor(.white).padding(.bottom, -8)
                                
                                HStack{
                                    Text("Participants:").font(.footnote).foregroundColor(.white)
                                    Image(systemName: "person.fill").foregroundColor(Color("reviewPurple"))
                                    Text(self.session.users?[1].firstName ?? "")
                                        .font(.footnote).foregroundColor(.white)
                                    Image(systemName: "person.fill").foregroundColor(Color("reviewPurple"))
                                    Text(self.session.users?[2].firstName ?? "")
                                        .onAppear(perform: handleOnAppear)
                                        .font(.footnote).foregroundColor(.white)
                                }
                            }.padding(.bottom, 5)
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            HStack{
                                Text("Review").font(.largeTitle).fontWeight(.bold).foregroundColor(Color("reviewPurple")).bold().padding(.bottom, -9)
                            }.offset(x: 250, y: -10)
                        }
                    }
                }
                
                .navigationViewStyle(StackNavigationViewStyle())

                
                //left menu
                Group(){
                    VStack(alignment: .leading){
                        
                        Button(action:{
                            self.readyToReturn = true
                        }){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Sessions overview")
                        }
                        .foregroundColor(Color.white)
                        .padding(.top,-15)
                        .padding(.leading, 3)
                        
                        Text("Highlights")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.top,5)
                            .frame(width: 299)
                        ScrollViewReader { value in
                            ScrollView{
                                if(self.instructorVM.eventsOfSession.count > 0){
                                    VStack(spacing: 0){
                                        ForEach(instructorVM.eventsOfSession) { event in
                                            
                                            
                                            Button(action: {
                                                self.selectedEvent = event
                                                updateNote(toPush: false)
                                            }) {
                                                
                                                EventCell(event: event, selected: event.equals(compareTo: selectedEvent) ? true : false)
                                                    .id(event.id)
                                            }.onAppear{
                                                if (self.selectedEvent == nil)
                                                {
                                                    selectedEvent = instructorVM.eventsOfSession.first
                                                    
                                                    updateNote(toPush: false)
                                                }
                                            }
                                        }
                                    }
                                }
                                else if (emptyEvents){
                                    Text("No events found in this session") .multilineTextAlignment(.center).foregroundColor(.white).font((.system(size: 18)))
                                        .frame(width: 200, height: 400, alignment: .center)
                                }
                                else{
                                    VStack{
                                        ProgressView("Loading...")
                                            .foregroundColor(Color("buttonColorBlue")).font((.system(size: 8)))
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                            .scaleEffect(x: 3, y: 3, anchor: .center)
                                            .onAppear{
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                                                    if(self.instructorVM.eventsAvailable == true){
                                                        emptyEvents = true
                                                    }
                                                }
                                            }
                                    }.frame(width: 200.0, height: 400.0).padding(.top)
                                }
                            }.frame(maxWidth: .infinity)
                                .frame(height: 640)
                                .background(.gray)
                        }
                    }.frame(width: 299, height: 761).background(Color("darkmodeColor1")).offset(x: -447.0, y: 36)
                }
                
                //notes
                ZStack(){
                    
                    //left side
                    VStack(alignment: .leading){
                        Text("Notes")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, -2)
                        
                        Text("Select a highlight to read the notes")
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
                                    .lineLimit(...2)
                                Image("note").opacity(selectedEvent?.feedbackFirstOfficer.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 100, height: 45)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.First_Officer ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.gray, width: 0.5)
                            
                            Button(action:{self.selectedPilot = PilotType.Both}){
                                Text("Both")
                                    .multilineTextAlignment(.center)
                                Image("note").opacity(selectedEvent?.feedbackAll.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 100, height: 45, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.Both ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.gray, width: 0.5)
                                .padding(.leading, -7)
                            
                            Button(action:{self.selectedPilot = PilotType.Captain}){
                                Text(" Captain")
                                    .multilineTextAlignment(.center)
                                Image("note").opacity(selectedEvent?.feedbackCaptain.isEmptyOrNil ?? false ? 0 : 1)
                            }.frame(width: 100, height: 45,alignment: .center)
                                .foregroundColor(Color.white)
                                .background(selectedPilot == PilotType.Captain ? Color("buttonColorBlue") : Color("darkmodeColor1"))
                                .border(.gray, width: 0.5)
                                .padding(.leading, -7)
                            
                            ZStack{
                                TextField("", text: $writtenNote)
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                    .frame(width:300, height: 200, alignment: Alignment.topLeading)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .position(x: -159, y: 181)
                                    .disabled(!canChangeNote)
                                
                                Group{
                                    Button(action:{
                                        if(self.canChangeNote == true){
                                            self.canChangeNote = false
                                        }
                                        else{
                                            self.canChangeNote = true
                                        }
                                    }){
                                        Image(systemName: "pencil").bold().font(.largeTitle)
                                    }.foregroundColor( self.canChangeNote ? Color.blue : Color.black)
                                        .opacity(isStudent ? 0 : 1)
                                       .padding(.trailing, 50)
                                    
                                    Button(action:{
                                        if(self.canChangeNote == true){
                                            self.canChangeNote = false
                                        }
                                        else{
                                            self.canChangeNote = true
                                        }
                                        
                                        self.writtenNote = ""
                                        self.noteRating = 0
                                        
                                    }){
                                        Text("X").bold().font(.largeTitle)
                                    }.foregroundColor(self.canChangeNote ? .blue : .black)
                                        .padding(.leading, 30)
                                } .position(x: -60, y: 250)
                            }
                            
                        }.frame(width: 550).position(x:300, y:30).onChange(of: self.selectedPilot) { value in
                            self.updateNote(toPush: false)
                        }
                        
                        VStack(){
                            
                            //rating
                            VStack(alignment: .leading){
                                Text("Rating: ").font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                                
                                RatingCell(rating: $noteRating).disabled(!canChangeNote)
                            }.position(x:470, y:-80)
                            
                            //progress and message
                            
                            if(self.changedNote){
                                
                                ProgressView("Loading").frame(width: 100, height: 100,alignment: .center).foregroundColor(.white) .progressViewStyle(CircularProgressViewStyle(tint: Color(.white))).position(x:460, y:-30).onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.changedNote = false
                                        self.successMessage = true
                                    }
                                }
                            }
                            else if(successMessage){
                                HStack{
                                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                    Text("Succesfully changed!").foregroundColor(.green).bold().onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            self.successMessage = false
                                        }
                                    }
                                }.frame(width: 200, height: 100,alignment: .center).position(x:460, y:-30)
                                
                            }
                            else{
                                Text("").frame(width: 100, height: 100,alignment: .center).position(x:460, y:-30)
                            }
                            
                            //button
                            Button(action:{
                                updateNote(toPush: true)
                                if(selectedEvent != nil){
                                    instructorVM.updateEvent(event: selectedEvent!)
                                }
                                instructorVM.getEvents(logbookId: self.video.logbookId)
                                updateNote(toPush: false)
                                
                                self.changedNote = true
                                
                            }){
                                Image(systemName: "doc.text")
                                    .foregroundColor(.white)
                                Text("Save changes")
                            }.frame(width: 159, height: 39)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .background(Color(canChangeNote && selectedEvent != nil ? "buttonColorPurple" : "buttonPurpleSelected"))
                                .cornerRadius(10)
                                .position(x:475, y:10)
                                .disabled(!canChangeNote)
                                .disabled(selectedEvent == nil)
                                .opacity(isStudent || selectedEvent == nil || !canChangeNote ? 0 : 1)
                        }
                    }.frame(width: 640, height: 239).position(x: 570, y: 115)
                }.frame(width: 888, height: 239).background(Color("darkmodeColor2")).position(x:746, y: 670)
            }
        }
    }
}

// MARK: Action handlers
private extension ReviewView {
    
    func handleOnAppear() {
        if(!instructorVM.eventsAvailable){
            instructorVM.getEvents(logbookId: self.video.logbookId)
        }
    }
    
    func updateNote(toPush: Bool){

        if(self.selectedEvent != nil){
            let note = self.writtenNote

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
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(session: Session(id: "1", startTime: Date.now, companyId: "1", videos: [], status: .Started), video: Video(id: "", videoName: nil, videoURL: nil, timeExpire: Date.now, sessionId: "1", logbookId: "1")).previewInterfaceOrientation(.landscapeLeft)
    }
}
