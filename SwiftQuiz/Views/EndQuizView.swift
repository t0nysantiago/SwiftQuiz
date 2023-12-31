//
//  EndQuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 30/12/23.
//

import SwiftUI

struct EndQuizView: View {
    @Binding var finalPoints: Int
    var body: some View {
        Text("You get \(finalPoints) points!")
    }
}

#Preview {
    EndQuizView(finalPoints: .constant(5))
}
