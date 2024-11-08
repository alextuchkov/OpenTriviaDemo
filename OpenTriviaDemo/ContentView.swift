//
//  ContentView.swift
//  OpenTriviaDemo
//
//  Created by Oleksandr Tuchkov on 08.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ViewModel()
    @State var questions: [Question] = []
    @State var tabIndex: Int = 0
    @State var score: Int = 0
    @State var isFinished: Bool = false
    
    var body: some View {
        VStack {
            if isFinished {
                Text("Your result: \(score)")
            } else if !questions.isEmpty {
                VStack {
                    Text("Score: \(score) / \(questions.count)")
                        .font(.title)
                 
                    TabView(selection: $tabIndex) {
                        ForEach(questions.indices, id: \.self) { index in
                            VStack {
                                Text(questions[index].decodedQuestion)
                                    .font(.title)
//                                Text(questions[index].correctAnswer)
                                TrueFalseButtons(score: $score, tabIndex: $tabIndex, questions: $questions, isFinished: $isFinished)
                            }
                            .tag(index)
                        }
                    }
                    .padding()
                    .tabViewStyle(PageTabViewStyle()) // Makes it a paginated slider
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
                
            } else {
                Text("Start quiz!")
                    .font(.largeTitle)
                Spacer()
            }
            
        }
        
        
    Button(action: {
        Task {
            do {
                questions = try await viewModel.getQuestions()
                score = 0
                tabIndex = 0
                isFinished = false
                
            } catch {
                print("Failed to refresh stories: \(error.localizedDescription)")
            }
        }
        
    }){
        Text(score > 0 ? "Re-start":"Start")
            .padding()
            .frame(width: 100)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
}

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



#Preview {
    ContentView()
}


