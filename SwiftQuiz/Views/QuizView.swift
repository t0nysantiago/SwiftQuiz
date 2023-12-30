//
//  QuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct QuizView: View {
    @Binding var triviaQuestions: [TriviaQuestion]
    @Environment(\.presentationMode) var presentationMode
    @Binding var backgroundColorChoosed: Color
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var answeredCorrectly: Bool? = nil
    
    var currentQuestion: TriviaQuestion? {
        guard triviaQuestions.indices.contains(currentQuestionIndex) else {
            return nil
        }
        return triviaQuestions[currentQuestionIndex]
    }

    
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
                    
                    Text("\(currentQuestionIndex + 1) / \(triviaQuestions.count)")
                        .font(.system(size: 14, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                    
                    if let currentQuestion = currentQuestion {
                        let shuffledAnswers = shuffleAnswers(correctAnswer: currentQuestion.correctAnswer, incorrectAnswers: currentQuestion.incorrectAnswers)
                        Text(currentQuestion.question)
                            .font(.system(size: 28, design: .rounded))
                            .bold()
                            .foregroundStyle(Color.appWhite)
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(0..<shuffledAnswers.count, id: \.self) { index in
                                Button(action: {
                                    if answeredCorrectly == nil {
                                        self.selectedAnswerIndex = index
                                        
                                        let selectedAnswer = shuffledAnswers[index]
                                        let isCorrect = selectedAnswer == currentQuestion.correctAnswer
                                        
                                        self.answeredCorrectly = isCorrect ? true : false
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            if self.answeredCorrectly != nil {
                                                self.currentQuestionIndex += 1
                                                self.selectedAnswerIndex = nil
                                                self.answeredCorrectly = nil
                                            }
                                        }
                                    }
                                }) {
                                    Text(shuffledAnswers[index])
                                        .foregroundColor(.black)
                                        .font(.system(size: 18, design: .rounded))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(
                                                    index == selectedAnswerIndex && answeredCorrectly != nil ?
                                                    (answeredCorrectly == true ? Color.green : Color.red) :
                                                        Color.white
                                                )
                                        )
                                }
                            }
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func shuffleAnswers(correctAnswer: String, incorrectAnswers: [String]) -> [String] {
        var allAnswers = [correctAnswer] + incorrectAnswers
        allAnswers.shuffle()
        return allAnswers
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
