//
//  ContentView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 26/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color.appOrange.ignoresSafeArea()
                VStack (spacing: 15){
                    
                    Spacer()
                    
                    logoSwiftView()
                    
                    Text("Continue with")
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                        .foregroundStyle(Color.appWhite)
                    
                    SOButtonView(logoImg: .constant("applelogo"), platformName: .constant("Apple"))
                    SOButtonView(logoImg: .constant("googlelogo"), platformName: .constant("Google"))
                    
                    SignEmailMessage()
                    
                    Spacer()
                    
                    FootMessage()
                }
            }
        }.navigationBarHidden(true)
    }
}

struct logoSwiftView: View {
    var body: some View {
        ZStack{
            RadialGradient(gradient: Gradient(colors: [.white, .clear]), center: .center, startRadius: 0, endRadius: 180)
                .frame(width: 400, height: 400)
            
            VStack (spacing: -15){
                Image("swiftimg")
                    .resizable()
                    .frame(width: 260.0, height: 120.0)
                    .rotationEffect(Angle.degrees(-5))
                
                
                
                Image("quizimg")
                    .resizable()
                    .frame(width: 140.0, height: 80.0)
                    .rotationEffect(Angle.degrees(-5))
            }
        }
    }
}

struct SignEmailMessage: View {
    @State private var isSignInViewActive = false
    
    var body: some View {
        ZStack {
            HStack(spacing: 5) {
                Text("or sign in via")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundStyle(Color.appWhite)
                
                Button(action: {
                    isSignInViewActive = true
                }) {
                    Text("email")
                        .font(.system(size: 17, design: .rounded))
                        .foregroundStyle(Color.appPurple)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())
                
            }
        }
        .background(
            NavigationLink(
                destination: SignInView(),
                isActive: $isSignInViewActive
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}

struct FootMessage: View {
    var body: some View {
        ZStack{
            HStack (spacing: 5) {
                Text("By continuing, you agree to the")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Color.appWhite)
                    
                
                Text("Terms")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Color.appPurple)
                    .bold()
                
                Text("and")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Color.appWhite)
                
                Text("Privacy Policy")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(Color.appPurple)
                    .bold()
            }
        }
    }
}

struct SOButtonView: View {
    @Binding var logoImg: String
    @Binding var platformName: String
    
    var body: some View {
        ZStack {
            Button(action: {
                
            }) {
                HStack {
                    Image(logoImg)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding()
                    
                    Text("Continue with \(platformName)")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20, design: .rounded))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
                .frame(width: 330, height: 55)
                .background(RoundedRectangle(cornerRadius: 15.0).foregroundStyle(Color.appWhite))
                
            }
        }
    }
}
