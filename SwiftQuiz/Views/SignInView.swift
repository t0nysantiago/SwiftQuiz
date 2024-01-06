//
//  SignInView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import SwiftUI
import SwiftData
import CryptoKit
import NavigationTransitions

struct SignInView: View {
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isHomeViewActive = false
    @State private var isSignUpViewActive = false
    @State private var showAlertBadLogin = false
    @State private var showAlertBadEmail = false
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appWhite.ignoresSafeArea()
                VStack (alignment: .center){
                    Spacer()
                    
                    Image(systemName: "questionmark.bubble.fill")
                        .font(.system(size: 130))
                        .foregroundStyle(.appOrange)
                    
                    Text("Welcome Back")
                        .font(.system(size: 30, design: .rounded))
                        .bold()
                        .foregroundStyle(.appOrange)
                    
                    Text("Sign to continue")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    CustomTextField(text: $emailText, placeholder: "Email")
                        .padding(.bottom)
                    CustomSecureField(text: $passwordText, placeholder: "Password")
                        .padding(.bottom)
                    
                    HStack {
                        Spacer()
                        Text("Forgot Password?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appOrange)
                    }.padding(.horizontal).padding(.bottom)
                    
                    Button(action: {
                        if validLogin() {
                            isHomeViewActive = true
                        }
                    }) {
                        ZStack{
                            Text("Login")
                                .foregroundColor(.appWhite)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .cornerRadius(15)
                        }
                        .frame(width: 350, height: 60)
                        .background(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(Color.appOrange)
                    }
                    .padding(.top, 15)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .alert("Email format is incorrect", isPresented: $showAlertBadEmail) {
                        Button("OK", role: .cancel) { showAlertBadEmail = false }
                    }
                    .alert("Email or password is incorrect", isPresented: $showAlertBadLogin) {
                        Button("OK", role: .cancel) { showAlertBadLogin = false }
                    }
                    .navigationDestination(isPresented: $isHomeViewActive) {
                        HomeView()
                    }
                    
                    HStack (spacing: 5) {
                        Text("Don't have account?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.gray)
                        Text("create a new account")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appOrange)
                            .onTapGesture {
                                isSignUpViewActive = true
                            }
                            .navigationDestination(isPresented: $isSignUpViewActive) {
                                SignUpView()
                            }
                    }
                    
                    Spacer()
                }.padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTransition(.slide)
    }
    
    func fetchData() -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        var users: [User] = []
        do {
            users = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        return users
    }
    
    func validLogin() -> Bool {
        let fetchedUsers = fetchData()
        
        if isValidEmail(email: emailText) == false {
            print("oiiiii")
            showAlertBadEmail = true
            return false
        }
        
        if let user = fetchedUsers.first(where: { $0.email == emailText }) {
            if user.password == hashPassword(password: passwordText) {
                userSettings.currentUser = user
                return true
            } else {
                showAlertBadLogin = true
                return false
            }
        } else {
            showAlertBadLogin = true
            return false
        }
    }
}
