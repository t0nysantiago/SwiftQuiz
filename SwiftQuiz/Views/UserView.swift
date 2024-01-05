//
//  UserView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI
import SwiftData

struct UserView: View {
    @State private var backToHome: Bool = false
    @State private var usernameText: String = ""
    @State private var emailText: String = ""
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
                    }.padding(.top, 40)
                    
                }
                .padding(.horizontal, 30)
            }
            .background(.appWhite)
            .scrollContentBackground(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
        
        if verifyIfUsernameOrEmailExists() == false {
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
        }
    }
    
    func verifyIfUsernameOrEmailExists() -> Bool {
        let fetchedUsers = fetchData()
        var usernameExists: Bool = false
        var emailExists: Bool = false

        if usernameText.isEmpty != true {
            usernameExists = fetchedUsers.contains { fetchedUser in
                return fetchedUser.username == usernameText
            }
        }

        if emailText.isEmpty != true {
            emailExists = fetchedUsers.contains { fetchedUser in
                return fetchedUser.email == emailText
            }
        }

        return usernameExists || emailExists
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
