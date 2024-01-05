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
                Color.appWhite.ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    Text("Create Account")
                        .font(.system(size: 35, design: .rounded))
                        .bold()
                        .foregroundStyle(.appOrange)
                    
                    Text("Create a new account")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(.gray)
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
                        if passwordsMatchAndIsValid() {
                            if isValidEmail() {
                                let newUser = User(username: username, email: email, password: password)
                                if verifyIfUsernameOrEmailExists(users: newUser) == false {
                                    addSample(user: newUser)
                                    addPhases(phases: Phases(userId: newUser.id))
                                    userSettings.currentUser = newUser
                                    isHomeViewActive = true
                                } else {
                                    showAlertUserExists = true
                                }
                            } else {
                                showAlertBadEmail = true
                            }
                        } else {
                            showAlertPasswordMismatch = true
                        }
                    }) {
                        ZStack{
                            Text("Register")
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
                    .alert("Passwords not match", isPresented: $showAlertPasswordMismatch) {
                        Button("OK", role: .cancel) { showAlertPasswordMismatch = false }
                    }
                    .alert("User or email already exists", isPresented: $showAlertUserExists) {
                        Button("OK", role: .cancel) { showAlertUserExists = false }
                    }
                    .alert("Password must contain at least 8 digits", isPresented: $showAlertBadPassword) {
                        Button("OK", role: .cancel) { showAlertBadPassword = false }
                    }
                    .alert("Email is incorrect", isPresented: $showAlertBadEmail) {
                        Button("OK", role: .cancel) { showAlertBadEmail = false }
                    }
                    .navigationDestination(isPresented: $isHomeViewActive) {
                        HomeView()
                    }
                    
                    HStack (spacing: 5) {
                        Text("Already have a account?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.gray)
                        Text("Login")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appOrange)
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
    
    func verifyIfUsernameOrEmailExists(users: User) -> Bool {
        let fetchedUsers = fetchData()

        let usernameExists = fetchedUsers.contains { fetchedUser in
            return fetchedUser.username == users.username
        }

        let emailExists = fetchedUsers.contains { fetchedUser in
            return fetchedUser.email == users.email
        }

        return usernameExists || emailExists
    }
    
    func passwordsMatchAndIsValid() -> Bool {
        var verification: Bool = false
        
        if password.count < 8 {
            showAlertBadPassword = true
            return verification
        }
        
        if password.isEmpty || confirmPassword.isEmpty {
            return verification
        }
        
        verification = password == confirmPassword
        
        return verification
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
