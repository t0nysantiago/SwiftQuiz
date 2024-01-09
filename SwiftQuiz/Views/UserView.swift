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
    @State private var imageURL: String = ""
    @State private var showAlertUserExists = false
    @State private var showAlertBadFields = false
    @State private var showAlertUserUpdated = false
    @State private var showChangeImg = false
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
                            .foregroundStyle(Color.appWhite)
                            .onTapGesture {
                                backToHome = true
                            }
                            .navigationDestination(isPresented: $backToHome) {
                                HomeView()
                            }
                        
                        Spacer()
                        
                        Text("Profile")
                            .font(.system(size: 25, design: .rounded))
                            .foregroundStyle(Color.appWhite)
                            .bold()
                            .padding()
                        
                        Spacer()
                        
                        Image(systemName: "door.right.hand.open")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.appWhite)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                    
                    ImageView(radius: .constant(200), imageURLString: .constant(userSettings.currentUser?.img_name))
                    
                    Text(userSettings.currentUser?.username ?? "Username")
                        .font(.system(size: 24, design: .rounded))
                        .bold()
                        .padding(.bottom, 20)
                    
                    CustomTextField(text: $usernameText, placeholder: "Username")
                    CustomTextField(text: $emailText, placeholder: "Email")
                    CustomTextField(text: $imageURL, placeholder: "Image URL")
                    
                    Button(action: {
                        updateUser()
                        showAlertUserUpdated = true
                    }) {
                        ZStack{
                            Text("Save")
                                .foregroundColor(.appOrange)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .cornerRadius(15)
                        }
                        .frame(width: 300, height: 60)
                        .background(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(Color.appWhite)
                    }
                    .padding(.top, 40)
                    .alert("Fill in the fields to update", isPresented: $showAlertBadFields) {
                        Button("OK", role: .cancel) { showAlertBadFields = false }
                    }
                    .alert("Email or username already exists", isPresented: $showAlertUserExists) {
                        Button("OK", role: .cancel) { showAlertUserExists = false }
                    }
                    .alert("User Updated", isPresented: $showAlertUserUpdated) {
                        Button("OK", role: .cancel) { showAlertUserUpdated = false ; backToHome = true }
                    }
                    
                }
                .padding(.horizontal)
            }
            .background(.appOrange)
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
        
        guard let currentUserID = userSettings.currentUser?.id else { return }
        guard let currentUserIndex = fetchedUsers.firstIndex(where: { $0.id == currentUserID }) else { return }
        let currentUser = fetchedUsers[currentUserIndex]
        
        guard !usernameText.isEmpty || !emailText.isEmpty || !imageURL.isEmpty else {
            showAlertBadFields = true
            return
        }
        
        if verifyIfUsernameOrEmailExists(usersFetched: fetchedUsers, username: usernameText, email: emailText) {
            showAlertUserExists = true
            return
        }
        
        if !usernameText.isEmpty {
            currentUser.username = usernameText
            usernameText = ""
        }
        
        if !emailText.isEmpty {
            currentUser.email = emailText
            emailText = ""
        }
        
        if !imageURL.isEmpty {
            currentUser.img_name = imageURL
            imageURL = ""
        }
    }
}
