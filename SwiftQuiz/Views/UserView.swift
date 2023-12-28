//
//  UserView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct UserView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (spacing: 20){
                        HStack{
                            Image(systemName: "chevron.backward.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.appGreen)
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            
                            Spacer()
                            
                            Text("Profile")
                                .font(.system(size: 25, design: .rounded))
                                .foregroundStyle(Color.appGreen)
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
                                .foregroundStyle(.appGreen)
                                .offset(CGSize(width: 70.0, height: 70.0))
                            
                            Circle()
                                .frame(width: 35)
                                .foregroundStyle(.appWhite)
                                .offset(CGSize(width: 70.0, height: 70.0))
                            
                            Image(systemName: "pencil")
                                .foregroundStyle(.appGreen)
                                .offset(CGSize(width: 70.0, height: 70.0))
                        }
                        
                        Text("Username")
                            .font(.system(size: 24, design: .rounded))
                            .bold()
                            .padding(.bottom, 20)
                        
                        CustomTextField(text: .constant("Username"), placeholder: "Username")
                        CustomTextField(text: .constant("teste@gmail.com"), placeholder: "Email")
                        CustomSecureField(text: .constant("12345678"), placeholder: "Password")
                        
                        Button(action: {
                        }) {
                            ZStack{
                                Text("Play")
                                    .foregroundColor(.appWhite)
                                    .font(.system(size: 18, design: .rounded))
                                    .bold()
                                    .cornerRadius(15)
                            }
                            .frame(width: 300, height: 60)
                            .background(RoundedRectangle(cornerRadius: 15.0))
                            .foregroundStyle(Color.appGreen)
                        }.padding(.top, 40)
                        
                    }.padding(.horizontal, 30)
            }
            .background(.appWhite)
            .scrollContentBackground(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.red : (isEditing ? Color.blue : Color.appGreen), lineWidth: 2)
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
    @State private var isEditing = false
    @State private var isError = false
    
    var body: some View {
        SecureField(placeholder, text: $text, onCommit: {
            self.isError = text.isEmpty
        })
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.red : (isEditing ? Color.blue : Color.appGreen), lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: text) { newValue in
            isError = newValue.isEmpty
        }
    }
}



#Preview {
    UserView()
}
