//
//  ContentView.swift
//  OpenTriviaDemo
//
//  Created by Oleksandr Tuchkov on 08.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var questions: [Question] = []
    @State private var tabIndex: Int = 0
    @State private var score: Int = 0
    @State private var isFinished: Bool = false
    @State private var selectedDifficulty: String = "easy"
    @State private var selectedAmount: String = "5"
    
    // adding settings
    
    var body: some View {
        VStack {
            if isFinished {
                ResultView(score: score, restartAction: startQuiz)
            } else if !questions.isEmpty {
                QuizSliderView(score: $score, questions: $questions, tabIndex: $tabIndex, isFinished: $isFinished)
            } else {
                StartView(
                    selectedDifficulty: $selectedDifficulty,
                    selectedAmount: $selectedAmount,
                    startQuizAction: startQuiz
                )
            }
        }
    }
    
    private func startQuiz() {
        Task {
            do {
                questions = try await viewModel.getQuestions(
                    amount: selectedAmount,
                    difficulty: selectedDifficulty
                )
                score = 0
                tabIndex = 0
                isFinished = false
            } catch {
                print("Failed to fetch questions: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}

struct QuizSliderView: View {
    @Binding var score: Int
    @Binding var questions: [Question]
    @Binding var tabIndex: Int
    @Binding var isFinished: Bool
    
    var body: some View {
        VStack {
            Text("Score: \(score) / \(questions.count)")
                .font(.title)
            
            TabView(selection: $tabIndex) {
                ForEach(questions.indices, id: \.self) { index in
                    VStack {
                        Text(questions[index].decodedQuestion)
                            .font(.title)
                        
                        TrueFalseButtons(score: $score, tabIndex: $tabIndex, questions: $questions, isFinished: $isFinished)
                    }
                    .tag(index)
                }
            }
            .padding()
            .tabViewStyle(PageTabViewStyle()) // Makes it a paginated slider
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct StartView: View {
    @Binding var selectedDifficulty: String
    @Binding var selectedAmount: String
    let startQuizAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Start quiz!")
                .font(.largeTitle)
            
            SettingsFormView(selectedDifficulty: $selectedDifficulty, selectedAmount: $selectedAmount)
            
            Spacer()
            Button(action: startQuizAction) {
                Text("Start")
                    .padding()
                    .frame(width: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct ResultView: View {
    var score: Int
    let restartAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Your result: \(score)")
            
            Button(action: restartAction) {
                Text("Re-start")
                    .padding()
                    .frame(width: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

struct SettingsFormView: View {
    @Binding var selectedDifficulty: String
    @Binding var selectedAmount: String
    
    let difficulties = ["easy", "medium", "hard"]
    let amounts = ["5", "10", "15"]
    
    var body: some View {
        Form {
            Section {
                Picker("Select Difficulty", selection: $selectedDifficulty) {
                    ForEach(difficulties, id: \.self) { difficulty in
                        Text(difficulty.capitalized)
                    }
                }
                .pickerStyle(.menu)
            }
            Section {
                Picker("Select Amount", selection: $selectedAmount) {
                    ForEach(amounts, id: \.self) { amount in
                        Text(amount)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}
