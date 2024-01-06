//
//  QuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI
import NavigationTransitions

struct QuizView: View {
    @State private var backToBeforeStart: Bool = false
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var answeredCorrectly: Bool? = nil
    @State private var shouldShowEndQuizView = false
    @State private var timerValue = 30
    @State private var allAnswer: [String] = []
    @State private var points: Int = 0
    @State private var countCorrectAnswer: Int = 0
    @Binding var triviaQuestions: [TriviaQuestion]
    @Binding var difficult: Difficult
    @Binding var logoImage: String
    @Binding var backgroundColorChoosed: Color
    @Environment(\.presentationMode) var presentationMode
    
    
    var currentQuestion: TriviaQuestion? {
        guard triviaQuestions.indices.contains(currentQuestionIndex) else {
            return nil
        }
        return triviaQuestions[currentQuestionIndex]
    }
    
    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerValue > 0 {
                self.timerValue -= 1
            } else {
                if currentQuestionIndex + 1 < triviaQuestions.count {
                    currentQuestionIndex += 1
                    timerValue = 30
                } else {
                    shouldShowEndQuizView = true
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView (showsIndicators: false) {
                ZStack (alignment: .leading) {
                    backgroundColorChoosed.ignoresSafeArea()
                    
                    VStack (alignment: .leading){
                        HStack {
                            Image(systemName: "chevron.backward.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.appWhite)
                                .onTapGesture {
                                    backToBeforeStart = true
                                }
                                .navigationDestination(isPresented: $backToBeforeStart) {
                                    BeforeStartView(backgroundColorChoosed: $backgroundColorChoosed, logoImage: $logoImage, difficult: $difficult)
                                }
                            
                            Spacer()
                            
                            Text("\(timerValue) seconds left")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        HStack{
                            Spacer()
                            Image(logoImage)
                                .resizable()
                                .frame(width: 280, height: 280)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Text("\(currentQuestionIndex + 1) / \(triviaQuestions.count)")
                            .font(.system(size: 14, design: .rounded))
                            .bold()
                            .foregroundColor(.white)
                            .navigationDestination(isPresented: $shouldShowEndQuizView) {
                                EndQuizView(finalPoints: $points, backgroundColorChoosed: $backgroundColorChoosed, difficult: $difficult, countCorrectAnswer: $countCorrectAnswer)
                            }
                        
                        if let currentQuestion = currentQuestion {
                            Text(currentQuestion.question)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size: 28, design: .rounded))
                                .bold()
                                .foregroundStyle(Color.appWhite)
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(0..<allAnswer.count, id: \.self) { index in
                                    Button(action: {
                                        if answeredCorrectly == nil {
                                            self.selectedAnswerIndex = index
                                            
                                            let selectedAnswer = allAnswer[index]
                                            let isCorrect = selectedAnswer == currentQuestion.correctAnswer
                                            
                                            self.answeredCorrectly = isCorrect ? true : false
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                if currentQuestionIndex + 1 < triviaQuestions.count {
                                                    if self.answeredCorrectly != nil {
                                                        earnOrLossPoints(answeredCorrectly: answeredCorrectly!)
                                                        self.currentQuestionIndex += 1
                                                        self.selectedAnswerIndex = nil
                                                        self.answeredCorrectly = nil
                                                        self.timerValue = 30
                                                        let currentQuestion = triviaQuestions[currentQuestionIndex]
                                                        self.allAnswer = unionAnswer(correctAnswer: currentQuestion.correctAnswer, incorrectAnswers: currentQuestion.incorrectAnswers)
                                                    } else {
                                                        earnOrLossPoints(answeredCorrectly: answeredCorrectly!)
                                                        self.currentQuestionIndex += 1
                                                        self.timerValue = 30
                                                        let currentQuestion = triviaQuestions[currentQuestionIndex]
                                                        self.allAnswer = unionAnswer(correctAnswer: currentQuestion.correctAnswer, incorrectAnswers: currentQuestion.incorrectAnswers)
                                                    }
                                                } else {
                                                    shouldShowEndQuizView = true
                                                }
                                            }
                                        }
                                    }) {
                                        Text(allAnswer[index])
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
                            .onAppear {
                                let currentQuestion = triviaQuestions[currentQuestionIndex]
                                let allAnswers = unionAnswer(correctAnswer: currentQuestion.correctAnswer, incorrectAnswers: currentQuestion.incorrectAnswers)
                                allAnswer = allAnswers
                            }
                        } else {
                            Text("Exit and try again!")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .frame(minHeight: 0, maxHeight: .infinity)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .onAppear {
                _ = timer
            }
            .background(backgroundColorChoosed)
            .scrollContentBackground(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTransition(.slide)
    }
    
    func unionAnswer(correctAnswer: String, incorrectAnswers: [String]) -> [String] {
        var allAnswers = [correctAnswer] + incorrectAnswers
        
        allAnswers.shuffle()
        
        return allAnswers
    }
    
    func earnOrLossPoints(answeredCorrectly: Bool) {
        if answeredCorrectly {
            addPoints(difficult: difficult)
            countCorrectAnswer += countCorrectAnswer
        }
    }
    
    func addPoints(difficult: Difficult) {
        switch difficult {
        case .easy:
            self.points += 5
        case .medium:
            self.points += 15
        case .hard:
            self.points += 50
        }
    }
}


