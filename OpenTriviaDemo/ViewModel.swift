//
//  ViewModel.swift
//  OpenTriviaDemo
//
//  Created by Oleksandr Tuchkov on 08.11.2024.
//

import SwiftUI
import Observation

@Observable
@MainActor
class ViewModel {
    
    
    func getQuestions() async throws -> [Question]  {
        var questions: [Question] = []
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=5&difficulty=easy&type=boolean") else {
            print("Invalid url")
            return []
     
        }
        
        do {

            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = try JSONDecoder().decode(Response.self, from: data)
            questions = response.results
            print(questions)
            print("-----")
            
            return questions

        }
        catch {
            print("Failed to fetch or decode data: \(error.localizedDescription)")
            throw error 
        }
    }
}
