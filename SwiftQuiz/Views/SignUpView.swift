//
//  SignUpView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @State private var isHomeViewActive = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlertPasswordMismatch = false
    @State private var showAlertUserExists = false
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
                    
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $isHomeViewActive
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
                    Button(action: {
                        if passwordsMatch() {
                            let newUser = User(username: username, email: email, password: password)
                            if verifyIfUsernameOrEmailExists(users: newUser) == false {
                                addSample(user: newUser)
                                userSettings.currentUser = newUser
                                isHomeViewActive = true
                            } else {
                                showAlertUserExists = true
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
                    .alert("Senhas não correspondem", isPresented: $showAlertPasswordMismatch) {
                        Button("OK", role: .cancel) { showAlertPasswordMismatch = false }
                    }
                    .alert("Usuário ou email já existe", isPresented: $showAlertUserExists) {
                        Button("OK", role: .cancel) { showAlertUserExists = false }
                    }
                    
                    HStack (spacing: 5) {
                        Text("Already have a account?")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.gray)
                        Text("Login")
                            .font(.system(size: 17, design: .rounded))
                            .foregroundStyle(.appOrange)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
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
    
    func passwordsMatch() -> Bool {
        var verification: Bool = false
        
        if password.isEmpty || confirmPassword.isEmpty {
            return verification
        }
        
        return password == confirmPassword
    }
}
