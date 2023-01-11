//
//  ReviewSession.swift
//  VRefSolution ios app
//
//  Created by Yassine on 01/01/2023.
//

import SwiftUI
import Combine

struct ReviewSession: View {
    
    @State private var isTryingToStart: Bool = false
    
    @State private var isReview: Bool = false
    //@State private var loadedUsers: Bool = false
    @State private var isInstructor: Bool = false
    
    @ObservedObject var mainMenuVM: MainMenuViewModel
    var session: Session
    
    var loadedUsers: Bool {self.session.users?.isEmpty != true}
    
    
    init(mainMenuVM: MainMenuViewModel, session: Session) {
        //fix runs muliple times.
        self.session = session
        self.mainMenuVM = mainMenuVM

        if self.session.users?.isEmpty == true {
            mainMenuVM.getUsersBySessionId(session: session)

            self.session = mainMenuVM.sessionsOfLoggedInUser.first(where: {$0.id == session.id})!
        }
    }
    
    var body: some View {

        VStack{
            //topbar
            Group{
                HStack{
                    Text(self.session.sessionName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                        .padding(.trailing)
                    Image("notFinished")
                        //.resizable()
                        //.aspectRatio(contentMode: .fill)
                        //.frame(width: 60, height: 60)
                        //.clipped()
                        //.fixedSize()
                        //.font(Font.system(.footnote)
                            //.weight(.semibold)).foregroundColor(.orange)
                        .opacity(session.status != .Finished ? 1 : 0)
                }
            }.frame(width: 680, height: 84).background(Color("darkmodeColor1")).offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -147.0)
            
            if(isTryingToStart){
                ProgressView().frame(width: 100, height: 210)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                    .scaleEffect(x: 4, y: 4, anchor: .center)
            }
            else{
                //Participants
                Group{
                    HStack(alignment: .firstTextBaseline){
                        Text("Participants").frame(width:101, alignment: .leading).font(.system(size: 18)).bold().foregroundColor(Color(.white)).padding(.trailing, 60)
                        
                        VStack(alignment: .leading){
                            Text("Role").font(.system(size: 16)).bold()
                            if session.users?.isEmpty == false{
                                ForEach(session.users!) { user in
                                    Text("\(user.role.rawValue)").font(.system(size: 14)).padding(2)
                                }
                            }
                            else{
                                ProgressView("Loading...")
                                    .foregroundColor(Color("buttonColorBlue")).font((.system(size: 8)))
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                    .scaleEffect(x: 2, y: 2, anchor: .top).padding(.leading)
                                    //.onAppear{ self.session = updateSession()}
                            }
                        }.padding(.leading).frame(width: 180, height: 130, alignment: .topLeading)
                        VStack(alignment: .leading){
                            Text("Name").font(.system(size: 16)).bold()
                            if session.users?.isEmpty == false{
                                ForEach(session.users!) { user in
                                    Text("\(user.firstName) \(user.lastName)").font(.system(size: 14)).padding(2)
                                }//.onAppear{self.loadedUsers = true}
                            }
                            else{
                                ProgressView("Loading...")
                                    .foregroundColor(Color("buttonColorBlue")).font((.system(size: 8)))
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                    .scaleEffect(x: 2, y: 2, anchor: .top).padding(.leading)//.onAppear{ self.session = updateSession()}
                            }
                        }.padding(.trailing).frame(width: 210, height: 130, alignment: .topLeading)

                    }
                    .frame(width:468, height: 58, alignment: Alignment.leading)
                    .offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -80.0)
                }//.onAppear(perform: getUsers)
                
                //Session
                Group{
                    HStack(alignment: .top){
                        Text("Session").frame(width:101, alignment: .leading).font(.system(size: 18)).bold().foregroundColor(Color(.white)).padding(.trailing, 105)
                        
                        Image("sessionPreview")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 252, height: 140).background(.yellow)
                            .clipped()
                    }
                }
                  
            }
            
            Button(action:{
                self.isTryingToStart = true;
                self.mainMenuVM.getVideo(sessionId: session.id)
                self.mainMenuVM.currentSession = self.session
                                
                if (self.session.status == .Started){
                    //session not done
                    
                    //self.isTryingToStart = true;
//                    self.mainMenuVM.getVideo(sessionId: session.id)
//                    self.mainMenuVM.currentSession = self.session
                    self.mainMenuVM.readyToContinue = true
                    self.isInstructor = true
                        //self.mainMenuVM.createSession(instructor: instructor);

                }
                else{
                    self.isReview = true
                    //get video
                    //self.mainMenuVM.getVideo(sessionId: self.session.id);
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                        //switch view
//                        self.mainMenuVM.readyToReview = true
//
//                    }
                    
                }
                
            }){
                Text(self.session.status == .Finished ? "Review" : "Continue")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }.frame(width: 237, height: 55)
                .background(Color(loadedUsers ? .systemBlue : .lightGray))
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .offset(y:80)
                .disabled(!loadedUsers)
            
        }.frame(width: 680, height: 659).background(Color("darkmodeColor2"))
            .onChange(of: self.isInstructor == true && mainMenuVM.video != nil && mainMenuVM.currentSession != nil) { _ in
                    self.mainMenuVM.readyToStart = true
            }
            .onChange(of: self.isReview == true && mainMenuVM.video != nil && mainMenuVM.currentSession != nil) { _ in
                    self.mainMenuVM.readyToReview = true
            }
//            .onChange(of: self.session){ _ in
//                if (self.session == true){
//                    self.loadedUsers = false
//                }
//            }
           
    }
}

private extension ReviewSession{
    
//    func getUsers() {
//        if(checkUsers){
//            mainMenuVM.getUsersBySessionId(session: self.session)
//            self.session = mainMenuVM.sessionsOfLoggedInUser.first(where: {$0.id == session.id})!
//        }
//    }
//
//    func updateSession() -> Session{
//            return mainMenuVM.sessionsOfLoggedInUser.first(where: {$0.id == session.id})!
//
//    }
}

struct ReviewSession_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSession(mainMenuVM: MainMenuViewModel(), session: Session(id: "1", startTime: Date.now, companyId: "1", videos: [], users: [
            User(id: "", email: "", firstName: "BigInstructor1", lastName: "BigInstructor1", userName: "", role: .ROLE_INSTRUCTOR, companyId: ""),
            User(id: "", email: "", firstName: "Pilot1", lastName: "Pilot1", userName: "", role: .ROLE_PILOT, companyId: ""),
            User(id: "", email: "", firstName: "Pilot2", lastName: "Pilot2", userName: "", role: .ROLE_PILOT, companyId: "")
            ], status: .Started))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
