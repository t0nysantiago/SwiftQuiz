//
//  TestView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @Query private var users: [User]
    var body: some View {
        List {
            Section("User") {
                ForEach(users) { user in
                    Text(user.password)
                }
            }
        }
    }
}

#Preview {
    TestView()
}
