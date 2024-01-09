//
//  CustomTextFieldView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 08/01/24.
//

import SwiftUI

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
                .stroke(isError ? Color.red : (isEditing ? Color.blue : Color.appWhite), lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: text) { oldValue, newValue in
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
                .stroke(isError ? Color.red : (isFocused ? Color.blue : Color.appWhite), lineWidth: 2)
        )
        .padding(.horizontal)
        .onChange(of: text) { oldValue, newValue in
            isError = newValue.isEmpty
        }
    }
}
