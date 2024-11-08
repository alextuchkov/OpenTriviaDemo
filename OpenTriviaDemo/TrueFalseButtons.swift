//
//  TrueFalseButtons.swift
//  OpenTriviaDemo
//
//  Created by Oleksandr Tuchkov on 08.11.2024.
//
import SwiftUI

struct TrueFalseButtons: View {
    @Binding var score: Int
    @Binding var tabIndex: Int
    @Binding var questions: [Question]
    @Binding var isFinished: Bool
    
    var body: some View {
        HStack {
            Button(action: {
            handleAnswer(selectedOption: true)
            }) {
                Text("True")
                    .padding()
                    .frame(width: 150)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                handleAnswer(selectedOption: false)
            }) {
                Text("False")
                    .padding()
                    .frame(width: 150)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private func handleAnswer(selectedOption: Bool) {
        let correct = questions[tabIndex].correctAnswer == "True"
        if correct == selectedOption {
            score += 1
        }
        if tabIndex == questions.count - 1 {
            isFinished = true
        } else {
            tabIndex += 1
        }
    }
}
