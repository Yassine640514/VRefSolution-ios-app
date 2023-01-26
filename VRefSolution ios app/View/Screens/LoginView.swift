//
//  LoginView.swift
//  VRefSolution ios app
//
//  Created by Yassine on 18/11/2022.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isTryingToLogin: Bool = false
    @State private var showingAlert = false
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
            
        if(loginVM.doneAuthentication){
            if(loginVM.isAuthenticated){
                MainMenuView()
            }
        }
        else{
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
                            Text("About").foregroundColor(Color("buttonColorBlue"))
                                .fontWeight(.bold)
                                .underline()
                                .font(.system(size: 18)).frame(width: 200)
                                .padding(.bottom)
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Text("Contact").foregroundColor(Color("buttonColorBlue"))
                                .fontWeight(.bold)
                                .underline()
                                .font(.system(size: 18))
                                .padding(.bottom)
                        }
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                //login form
                Group(){
                    
                    VStack(alignment:.center, spacing: 20){
                        Image("LoginLogo")
                            .offset(x:-20, y:-40)
                        if isTryingToLogin{
                            ProgressView().frame(width: 100, height: 150)
                                .padding(.bottom)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("buttonColorBlue")))
                                .scaleEffect(x: 4, y: 4, anchor: .center)
                        }
                        else{
                            
                            HStack{
                                Text("Email")
                                    .padding(.bottom, 4.0)
                                    .padding(.leading, 15.0)
                                TextField("johndoe@vrefsolutions.com:", text: $loginVM.username)
                                    .padding(.bottom, 4.0)
                                    .padding(.leading, 45.0)
                            }.frame(width:468, height: 44, alignment: Alignment.center)
                                .background(Color.white)
                                .cornerRadius(5)
                            HStack{
                                
                                Text("Password")
                                    .padding(.bottom, 4.0)
                                    .padding(.leading, 15.0)
                                SecureField("Enter password", text: $loginVM.password)
                                    .padding(.bottom, 4.0)
                                    .padding(.leading, 15.0)
                                
                            }.frame(width:468, height: 44, alignment: Alignment.center)
                                .background(Color.white)
                                .cornerRadius(5)
                            
                            
                            HStack{
                                Text("Reset password")
                                    .padding(.trailing, 210)
                                    .foregroundColor(Color("buttonColorBlue"))
                                    .underline()
                                    .bold()
                                    .font(.system(size: 20))
                                
                                Button("Login") {
                                    if (!loginVM.username.isEmpty && !loginVM.password.isEmpty){
                                        isTryingToLogin = true
                                        loginVM.login()
                                    }
                                    else{
                                        loginVM.error = AuthenticationError.usernameOrPasswordEmpty
                                        loginVM.hasError = true
                                        self.showingAlert = true
                                    }
                                    
                                    if loginVM.error != nil{
                                        self.showingAlert = true
                                    }
                                    
                                }.keyboardShortcut(.defaultAction)
                                    .frame(width: 100, height: 36)
                                    .background(Color("buttonColorBlue"))
                                    .foregroundColor(.white)
                            }
                        }
                        
                    }
                }.frame(width: 700, height: 500, alignment: Alignment.center).background(Color("darkmodeColor1"))
                    .cornerRadius(10)
                
            }.alert(isPresented: $loginVM.hasError, error: loginVM.error) {
                error in
                
                
                Button("Retry", role: nil, action: {
                    loginVM.error = nil;
                    loginVM.hasError = false;
                    self.isTryingToLogin = false
                    
                })
                
                
            } message: { error in
                Text("Please try again!")
            }
        }
        
        if(!networkManager.isConnected){
            NoConnectionView()
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
