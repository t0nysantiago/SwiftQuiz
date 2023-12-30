//
//  UserView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct UserView: View {
    @State private var usernameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 20){
                    HStack{
                        Image(systemName: "chevron.backward.circle")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.appOrange)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        Spacer()
                        
                        Text("Profile")
                            .font(.system(size: 25, design: .rounded))
                            .foregroundStyle(Color.appOrange)
                            .bold()
                            .padding()
                        
                        Spacer(minLength: 125)
                    }
                    
                    ZStack{
                        Circle()
                            .frame(width: 200)
                            .foregroundStyle(.appPurple)
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
                    
                    Text("Username")
                        .font(.system(size: 24, design: .rounded))
                        .bold()
                        .padding(.bottom, 20)
                    
                    CustomTextField(text: $usernameText, placeholder: "Username")
                    CustomTextField(text: $emailText, placeholder: "Email")
                    CustomSecureField(text: $passwordText, placeholder: "Password")
                    
                    Button(action: {
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
                .onAppear {
                    if let user = userInformation {
                        usernameText = user.username
                        emailText = user.email
                    }
                }
            }
            .background(.appWhite)
            .scrollContentBackground(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    var userInformation: User? {
        userSettings.currentUser
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
        .onChange(of: text) { newValue in
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
        .onChange(of: text) { newValue in
            isError = newValue.isEmpty
        }
    }
}
