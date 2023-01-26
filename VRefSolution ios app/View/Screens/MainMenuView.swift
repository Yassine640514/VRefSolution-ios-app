//
//  MainMenuView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 21/11/2022.
//

import SwiftUI

struct MainMenuView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var mainMenuVM = MainMenuViewModel()
    @State var selectedSession: Session?
    
    @State var showSessionPopup : Bool = false
    @State var showReviewPopUp : Bool = false
    @State var emptySession : Bool = false
    
    var body: some View {
        if(mainMenuVM.readyToStart){
            InstructorView(session: mainMenuVM.currentSession!, video: mainMenuVM.video!, isContinuing: mainMenuVM.readyToContinue)
        }
        else if(mainMenuVM.readyToReview){
            ReviewView(session: mainMenuVM.currentSession!, video: mainMenuVM.video!)
        }
        else if (loginVM.isAuthenticated){
            ZStack(){
                //Topbar
                NavigationView(){
                    VStack(){
                        //background color
                        Color("darkmodeColor2").edgesIgnoringSafeArea(.all)
                    }
                    .toolbarBackground(Color("topbarColor"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Image("shortLogo").padding(.bottom)
                        }
                        ToolbarItem(placement: .navigationBarLeading){
                            Text("VRef Solutions")
                                .foregroundColor(Color("buttonColorBlue"))
                                .fontWeight(.bold)
                                .font(.system(size: 25)).frame(width: 200)
                                .padding(.bottom)
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action:{loginVM.logout()}){
                                Text("Logout")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("buttonColorBlue"))
                                    .underline()
                                    .font(.system(size: 18))
                                    .padding(.bottom)
                            }
                            
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                
                //left menu
                Group(){
                    VStack(){
                        
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.white).frame(width: 280, height: 0, alignment: Alignment.trailing).padding(.bottom)
                        
                        Text("Welcome \(loginVM.firstName!)!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            .offset(x: 0, y: -5)
                        
                        Text("Recent")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                            .offset(x: -100, y: -5)
                        ScrollViewReader { value in
                            ScrollView{
                                if(mainMenuVM.sessionsOfLoggedInUser.count > 0 && mainMenuVM.getSessionOfLastDayByRole(role: UserType(rawValue: loginVM.userRole!)!).count > 0)
                                {
                                    LazyVStack{
                                        ForEach(mainMenuVM.getSessionOfLastDayByRole(role: UserType(rawValue: loginVM.userRole!)!)) { session in
                                            Button(action: {
                                                self.selectedSession = session
                                                self.showReviewPopUp = true
                                                self.showSessionPopup = false
                                                value.scrollTo(selectedSession!.id)
                                            }) {
                                                SessionCell(session: session, selected: session.equals(compareTo: selectedSession) ? true : false)
                                                    .id(session.id)
                                                    .padding(.bottom, -7)
                                            }
                                            
                                        }.frame(maxWidth: .infinity)
                                    }
                                }
                                else if (emptySession){
                                    Text("No session found in the last 24 hours") .foregroundColor(.white).font((.system(size: 18)))
                                        .frame(width: 200, height: 400, alignment: .center)
                                }
                                else{
                                    VStack{
                                        ProgressView("Loading...")
                                            .foregroundColor(Color("buttonColorBlue")).font((.system(size: 8)))
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                            .scaleEffect(x: 3, y: 3, anchor: .center)
                                            .onAppear{
                                                //after 10 sec loading, show error message
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                                                    emptySession = true
                                                }
                                            }
                                    }.frame(width: 500.0, height: 500.0).padding(.top)
                                        .onAppear(perform: handleOnAppear)
                                }
                            }.frame(height: 550)
                        }
                        
                        Button(action:{self.showSessionPopup = true; self.showReviewPopUp = false; self.selectedSession = nil}){
                            Image(systemName: "plus").foregroundColor(.white)
                            Text(" New Session")
                        }.frame(width: 237, height: 55)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .background(Color("buttonColorBlue"))
                            .cornerRadius(20.0)
                            .offset(x: 0, y: 5)
                            .opacity(loginVM.userRole == UserType.ROLE_INSTRUCTOR.rawValue ? 1 : 0)
                        
                    }.frame(width: 299, height: 761).background(Color("darkmodeColor1")).offset(x: -447.0, y: 36)
                }
                
                
                //right content
                Group(){
                    VStack(){
                        if(showSessionPopup){
                            NewSession(mainMenuVM: mainMenuVM, instructor: User(id: loginVM.userId!, email: "", firstName: "", lastName: "", userName: loginVM.username, role: UserType(rawValue: loginVM.userRole!)!, companyId: loginVM.companyId!))
                        }
                        else if (showReviewPopUp){
                            ReviewSession(mainMenuVM: mainMenuVM, session: selectedSession!)
                        }
                        else{
                            Text("Select a session to review").foregroundColor(Color("lightGreyText"))
                        }
                        
                    }.frame(width: 892, height: 759).background(Color("backgroundColor")).offset(x: 148.5, y: 35)
                }
            }
        }
    }
}


// MARK: Action handlers
private extension MainMenuView {

    func handleOnAppear() {
        if(mainMenuVM.sessionsOfLoggedInUser.isEmpty){
           mainMenuVM.getSessions()
        }
    }
}


struct MainMenuView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(LoginViewModel())
    }
}
