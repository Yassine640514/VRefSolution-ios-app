//
//  NewSession.swift
//  VRefSolution ios app
//
//  Created by Yassine on 22/11/2022.
//

import SwiftUI

struct NewSession: View {
    
    @State private var isTryingToStart: Bool
    @ObservedObject var mainMenuVM: MainMenuViewModel
    private var placeholderFo: String
    private var placeholderCap: String
    
    let instructor: User
    
    init(mainMenuVM: MainMenuViewModel, instructor: User) {
        mainMenuVM.setSessionDateAndName()
        
        self.mainMenuVM = mainMenuVM
        self.instructor = instructor
        self.isTryingToStart = false
        self.placeholderFo = "Select first officer"
        self.placeholderCap = "Select Captain"
    }
    
    var body: some View {
        
        VStack{
            //topbar
            Group{
                Text("New session")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            }.frame(width: 680, height: 84).background(Color("darkmodeColor1")).offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -147.0)
            
            if(isTryingToStart){
                ProgressView().frame(width: 100, height: 210)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                    .scaleEffect(x: 4, y: 4, anchor: .center)
            }
            else{
                //session name
                Group{
                    HStack{
                        Text("Session name")
                            .padding(.bottom, 4.0)
                            .padding(.leading, 15.0)
                        Text(mainMenuVM.sessionName!)
                            .padding(.bottom, 4.0)
                            .padding(.leading, 45.0)
                    }
                    .frame(width:468, height: 44, alignment: Alignment.leading)
                    .background(Color.white)
                    .cornerRadius(5)
                    .offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -80.0)
                }.onAppear{mainMenuVM.getUsers()}
                
                //First officer
                Group{
                    HStack{
                        Text("First officer")
                            .padding(.bottom, 4.0)
                            .padding(.leading, 15.0)
                        
                        Menu {
                            ForEach(mainMenuVM.getPilots()){ FO in
                                if(mainMenuVM.captain != nil && mainMenuVM.captain!.equals(compareTo: FO)){
                                    //skip
                                }
                                else{
                                    Button("\(FO.firstName) \(FO.lastName)") {
                                        mainMenuVM.firstOfficer = FO
                                    }
                                }
                            }
                        } label: {
                            HStack{
                                Text(mainMenuVM.firstOfficer == nil ? placeholderFo : "\(mainMenuVM.firstOfficer!.firstName) \(mainMenuVM.firstOfficer!.lastName)")
                                    .foregroundColor(mainMenuVM.firstOfficer == nil ? Color("lightGreyText") : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.gray)
                                    .font(Font.system(size: 20, weight: .bold))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 4.0)
                        .padding(.leading, 45.0)
                    }.frame(width:468, height: 44, alignment: Alignment.center)
                        .background(Color.white)
                        .cornerRadius(5)
                        .offset(y: -30.0)
                    
                    HStack{
                        Image(systemName: "checkmark.square.fill").foregroundColor(Color.white)
                        
                        Text("I give consent to be recorded during this session").font(.callout).fontWeight(.regular).foregroundColor(Color.white)
                    }
                    .offset(x: /*@START_MENU_TOKEN@*/-15.0/*@END_MENU_TOKEN@*/, y: -30.0)
                }
                
                //Captain
                Group{
                    HStack{
                        Text("Captain")
                            .padding(.bottom, 4.0)
                            .padding(.leading, 15.0)
                            .padding()
                        
                        Menu {
                            ForEach(mainMenuVM.getPilots()){ Cap in
                                if(mainMenuVM.firstOfficer != nil && mainMenuVM.firstOfficer!.equals(compareTo: Cap)){
                                    //skip
                                }
                                else{
                                    Button("\(Cap.firstName) \(Cap.lastName)") {
                                        mainMenuVM.captain = Cap
                                    }
                                }
                            }
                        } label: {
                            HStack{
                                Text(mainMenuVM.captain == nil ? placeholderCap : "\(mainMenuVM.captain!.firstName) \(mainMenuVM.captain!.lastName)")
                                    .foregroundColor(mainMenuVM.captain == nil ? Color("lightGreyText") : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.gray)
                                    .font(Font.system(size: 20, weight: .bold))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 4.0)
                        .padding(.leading, 45.0)
                    }.frame(width:468, height: 44, alignment: Alignment.center)
                        .background(Color.white)
                        .cornerRadius(5)
                        .offset(y: -1.0)
                    
                    HStack{
                        Image(systemName: "checkmark.square.fill").foregroundColor(Color.white)
                        
                        Text("I give consent to be recorded during this session").font(.callout).fontWeight(.regular).foregroundColor(Color.white)
                    }
                    .offset(x: /*@START_MENU_TOKEN@*/-15.0/*@END_MENU_TOKEN@*/, y: -1)
                }
            }
            Button(action:{self.isTryingToStart = true;
                self.mainMenuVM.createSession(instructor: instructor);
            }){
                Text("Start")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }.frame(width: 237, height: 55)
                .background(Color(allFieldsFilled ? .systemBlue : .lightGray))
                .cornerRadius(/*@START_MENU_TOKEN@*/20.0/*@END_MENU_TOKEN@*/)
                .offset(y:80)
                .disabled(!allFieldsFilled)
            
            
        }.frame(width: 680, height: 659).background(Color("darkmodeColor2"))
            .onChange(of: mainMenuVM.isCreated) { _ in
                if (mainMenuVM.isCreated){
                    self.mainMenuVM.readyToStart = true
                }
            }
    }
}

private extension NewSession{
    
    var allFieldsFilled: Bool {
        if (mainMenuVM.firstOfficer == nil || mainMenuVM.captain == nil)
        {
            return false
        }
        else{
            return true
        }
    }
}

struct NewSession_Previews: PreviewProvider {
    static var previews: some View {
        NewSession(mainMenuVM: MainMenuViewModel(), instructor: User(id: "1", email: "mail", firstName: "name", lastName: "lastname", userName: "username", role: .ROLE_INSTRUCTOR, companyId: "1"))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}


