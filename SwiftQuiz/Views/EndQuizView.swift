//
//  EndQuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 30/12/23.
//

import SwiftUI

struct EndQuizView: View {
    @State private var showAlertError: Bool = false
    @State private var isToBackHome: Bool = false
    @Binding var finalPoints: Int
    @Binding var backgroundColorChoosed: Color
    @Environment (\.modelContext) var modelContext
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColorChoosed.ignoresSafeArea()
                VStack {
                    
                    NavigationLink (
                        destination: HomeView(),
                        isActive: $isToBackHome
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
                    if finalPoints > 0 {
                        Spacer()
                        
                        ImageToShowEndQuizView(logoName: .constant("gift"), logoColor: .constant(Color.green))
                        
                        Text("Congratulations!")
                            .font(.system(size: 30, design: .rounded))
                            .bold()
                            .foregroundStyle(.appWhite)
                        Text("You got \(finalPoints) points")
                            .font(.system(size: 20, design: .rounded))
                            .foregroundStyle(.appWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            if let user = userSettings.currentUser {
                                let newPoints = Points(userId: user.id, point: finalPoints)
                                modelContext.insert(newPoints)
                                isToBackHome = true
                            } else {
                                showAlertError = true
                            }
                        }, label: {
                            Text("Done")
                                .font(.system(size: 20, design: .rounded))
                                .foregroundStyle(backgroundColorChoosed)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .fill(.appWhite)
                                )
                        })
                        .padding(.horizontal, 40)
                        .alert("Erro inesperado", isPresented: $showAlertError) {
                            Button("OK", role: .cancel) { showAlertError = false }
                        }
                        
                        Spacer()
                    } else {
                        Spacer()
                        
                        ImageToShowEndQuizView(logoName: .constant("arrow.counterclockwise.circle"), logoColor: .constant(Color.red))
                        
                        Text("Ohhh no!")
                            .font(.system(size: 30, design: .rounded))
                            .bold()
                            .foregroundStyle(.appWhite)
                        Text("You lost \(finalPoints) points")
                            .font(.system(size: 20, design: .rounded))
                            .foregroundStyle(.appWhite)
                        
                        Spacer()
                        
                        Button(action: {
                            if let user = userSettings.currentUser {
                                let newPoints = Points(userId: user.id, point: finalPoints)
                                modelContext.insert(newPoints)
                                isToBackHome = true
                            } else {
                                showAlertError = true
                            }
                        }, label: {
                            Text("Done")
                                .font(.system(size: 20, design: .rounded))
                                .foregroundStyle(backgroundColorChoosed)
                                .bold()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .fill(.appWhite)
                                )
                        })
                        .padding(.horizontal, 40)
                        .alert("Erro inesperado", isPresented: $showAlertError) {
                            Button("OK", role: .cancel) { showAlertError = false }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ImageToShowEndQuizView: View {
    @Binding var logoName: String
    @Binding var logoColor: Color
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.white, .clear]), center: .center, startRadius: 0, endRadius: 180)
                .frame(width: 400, height: 400)
            
            Image(systemName: logoName)
                .font(.system(size: 150))
                .foregroundStyle(logoColor)
        }

    }
}

#Preview {
    EndQuizView(finalPoints: .constant(-1), backgroundColorChoosed: .constant(.appOrange))
}
