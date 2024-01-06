//
//  UserView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI
import SwiftData
import NavigationTransitions

struct UserView: View {
    @State private var backToHome: Bool = false
    @State private var usernameText: String = ""
    @State private var emailText: String = ""
    @State private var showAlertUserExists = false
    @State private var showAlertBadFields = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 20){
                    HStack{
                        Image(systemName: "chevron.backward.circle")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.appOrange)
                            .onTapGesture {
                                backToHome = true
                            }
                            .navigationDestination(isPresented: $backToHome) {
                                HomeView()
                            }
                        
                        Spacer()
                        
                        Text("Profile")
                            .font(.system(size: 25, design: .rounded))
                            .foregroundStyle(Color.appOrange)
                            .bold()
                            .padding()
                        
                        Spacer()
                        
                        Image(systemName: "door.right.hand.open")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.appOrange)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    
                    ZStack{
                        Image("userlogo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.appOrange)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.appOrange, lineWidth: 2))
                            .padding(.horizontal, 5)
                        Circle()
                            .frame(width: 40)
                            .foregroundStyle(.appOrange)
                            .offset(CGSize(width: 70.0, height: 70.0))
                        
                        Circle()
                            .frame(width: 35)
                            .foregroundStyle(.appWhite)
                            .offset(CGSize(width: 70.0, height: 70.0))
                        
                        Image(systemName: "pencil")
                            .foregroundStyle(.appOrange)
                            .offset(CGSize(width: 70.0, height: 70.0))
                    }
                    
                    Text(userSettings.currentUser?.username ?? "Username")
                        .font(.system(size: 24, design: .rounded))
                        .bold()
                        .padding(.bottom, 20)
                    
                    CustomTextField(text: $usernameText, placeholder: "Username")
                    CustomTextField(text: $emailText, placeholder: "Email")
                    
                    Button(action: {
                        updateUser()
                    }) {
                        ZStack{
                            Text("Save")
                                .foregroundColor(.appWhite)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .cornerRadius(15)
                        }
                        .frame(width: 300, height: 60)
                        .background(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(Color.appOrange)
                    }
                    .padding(.top, 40)
                    .alert("Fill in the fields to update", isPresented: $showAlertBadFields) {
                        Button("OK", role: .cancel) { showAlertBadFields = false }
                    }
                    .alert("Email or username already exists", isPresented: $showAlertUserExists) {
                        Button("OK", role: .cancel) { showAlertUserExists = false }
                    }
                    
                }
                .padding(.horizontal, 30)
            }
            .background(.appWhite)
            .scrollContentBackground(.hidden)
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
    
    func updateUser() {
        let fetchedUsers = fetchData()
        
        if usernameText.isEmpty != true || emailText.isEmpty != true {
            if verifyIfUsernameOrEmailExists(usersFetched: fetchedUsers, username: usernameText, email: emailText) == false {
                if let user = fetchedUsers.first(where: { $0.id == userSettings.currentUser?.id }) {
                    if usernameText.isEmpty != true && emailText.isEmpty != true {
                        user.username = usernameText
                        user.email = emailText
                    } else if usernameText.isEmpty != true {
                        user.username = usernameText
                    } else if emailText.isEmpty != true {
                        user.email = emailText
                    }
                }
            } else {
                showAlertUserExists = true
            }
        } else {
            showAlertBadFields = true
        }
    }
    
    
    
}

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    @State private var isEditing = false
    @State private var isError = false
    
    var body: some View {
        TextField(placeholder, text: $text, onEditingChanged: { editing in
            self.isEditing = editing
            self.isError = false
        })
        .autocapitalization(.none)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.red : (isEditing ? Color.blue : Color.appOrange), lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: text) { oldValue, newValue in
            isError = newValue.isEmpty
        }
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    var placeholder: String
    @State private var isError = false
    @FocusState private var isFocused: Bool

    var body: some View {
        SecureField(placeholder, text: $text) {
            self.isError = text.isEmpty
        }
        .autocapitalization(.none)
        .focused($isFocused)
        .submitLabel(.done)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.red : (isFocused ? Color.blue : Color.appOrange), lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: text) { oldValue, newValue in
            isError = newValue.isEmpty
        }
    }
}
