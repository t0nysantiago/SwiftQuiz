//
//  SignUpView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @State private var backToSignIn: Bool = false
    @State private var isHomeViewActive = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlertPasswordMismatch = false
    @State private var showAlertUserExists = false
    @State private var showAlertBadPassword = false
    @State private var showAlertBadEmail = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appOrange.ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    Text("Create Account")
                        .font(.system(size: 35, design: .rounded))
                        .bold()
                        .foregroundStyle(.appWhite)
                    
                    Text("Create a new account")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.appWhite)
                        .padding(.bottom, 50)
                    
                    
                    CustomTextField(text: $username, placeholder: "Username")
                        .padding(.bottom)
                    CustomTextField(text: $email, placeholder: "Email")
                        .padding(.bottom)
                    CustomSecureField(text: $password, placeholder: "Password")
                        .padding(.bottom)
                    CustomSecureField(text: $confirmPassword, placeholder: "Confirm Password")
                        .padding(.bottom)
                    
                    Button(action: {
                        createUser(username: username, email: email, password: password, confirmPassword: confirmPassword)
                    }) {
                        ZStack{
                            Text("Register")
                                .foregroundColor(.appOrange)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .cornerRadius(15)
                        }
                        .frame(width: 350, height: 60)
                        .background(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(Color.appWhite)
                    }
                    .padding(.top, 15)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .alert("Email is incorrect", isPresented: $showAlertBadEmail) {
                        Button("OK", role: .cancel) { showAlertBadEmail = false }
                    }
                    .alert("Password must contain at least 8 digits", isPresented: $showAlertBadPassword) {
                        Button("OK", role: .cancel) { showAlertBadPassword = false }
                    }
                    .alert("Passwords not match", isPresented: $showAlertPasswordMismatch) {
                        Button("OK", role: .cancel) { showAlertPasswordMismatch = false }
                    }
                    .alert("User or email already exists", isPresented: $showAlertUserExists) {
                        Button("OK", role: .cancel) { showAlertUserExists = false }
                    }
                    .navigationDestination(isPresented: $isHomeViewActive) {
                        HomeView()
                    }
                    
                    HStack (spacing: 5) {
                        Text("Already have a account?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appWhite)
                        Text("Login")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appPurple)
                            .onTapGesture {
                                backToSignIn = true
                            }
                            .navigationDestination(isPresented: $backToSignIn) {
                                SignInView()
                            }
                    }
                    
                    Spacer(minLength: 130)
                    
                }.padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func addSample(user: User) {
        modelContext.insert(user)
    }
    
    func addPhases(phases: Phases) {
        modelContext.insert(phases)
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
    
    func createUser(username: String, email: String, password: String, confirmPassword: String) {
        guard isValidEmail(email: email) else {
            showAlertBadEmail = true
            return
        }
        
        guard passwordIsValid(password: password) else {
            showAlertBadPassword = true
            return
        }
        
        guard passwordsMatch(password: password, confirmPassword: confirmPassword) else {
            showAlertPasswordMismatch = true
            return
        }
        
        let newUser = User(username: username, email: email, password: password)
        
        guard !verifyIfUsernameOrEmailExists(usersFetched: fetchData(), username: username, email: email) else {
            showAlertUserExists = true
            return
        }
        
        addSample(user: newUser)
        addPhases(phases: Phases(userId: newUser.id))
        userSettings.currentUser = newUser
        isHomeViewActive = true
    }

}

#Preview {
    SignUpView()
}
