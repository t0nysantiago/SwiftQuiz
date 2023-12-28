//
//  QuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct QuizView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var backgroundColorChoosed: Color
    var body: some View {
        NavigationView {
            ZStack (alignment: .leading) {
                backgroundColorChoosed.ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    HStack {
                        Image(systemName: "chevron.backward.circle")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.appWhite)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                        
                        Spacer()
                        
                        CountdownTimerView()
                        
                        Spacer(minLength: 150)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Image("history")
                            .resizable()
                            .frame(width: 300, height: 250)
                        Spacer()
                    }
                    Spacer()
                    
                    Text("5 / 10")
                        .font(.system(size: 14, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                    Text("Some Question to ask ?")
                        .font(.system(size: 28, design: .rounded))
                        .bold()
                        .foregroundStyle(Color.appWhite)
                    
                    ForEach (0..<4) { index in
                        Button(action: {
                            
                        }) {
                            ZStack{
                                Text("Answer")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, design: .rounded))
                                    .cornerRadius(15)
                            }
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 15.0))
                            .foregroundStyle(Color.appWhite)
                        }
                    }
                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct CountdownTimerView: View {
    @State private var timeRemaining: CGFloat = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let totalTime: CGFloat = 30.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0, to: timeRemaining)
                    .stroke(Color.appWhite, lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(totalTime - (totalTime * Double(timeRemaining))))")
                    .font(.largeTitle)
                    .foregroundColor(.appWhite)
            }
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1 / totalTime
            }
        }
    }
}


#Preview {
    QuizView(backgroundColorChoosed: .constant(.appGreen))
}
