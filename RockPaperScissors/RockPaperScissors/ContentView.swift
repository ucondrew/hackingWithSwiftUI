//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Andrew Garcia on 4/20/21.
//

import SwiftUI

struct ContentView: View {
    let moves = ["Rock", "Paper", "Scissors"]
    @State private var score = 0
    @State private var computerAnswer = 0
    @State private var shouldWin = true
    @State private var gameCount = 1
    @State private var showingScore = false
    var outcome: String {
        if shouldWin {
            return "win"
        } else {
            return "lose"
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Computer chooses... \(moves[computerAnswer])!")
                
                VStack(spacing: 40) {
                    ForEach(0 ..< moves.count) { number in
                        Button("\(moves[number])") {
                            self.buttonTapped(number)
                        }
                        .padding()
                        .font(.title)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    Spacer()
                    Section(header: Text("Score")) {
                        Text("\(score)")
                            .font(.title)
                        
                        
                }
            }
            .navigationBarTitle("Try to \(outcome)!")
                
                .alert(isPresented: $showingScore) {
                    Alert(title: Text("Final Score"), message: Text("\(score)"), dismissButton: .default(Text("Play again")) {
                        self.promptUser()
                    })
                    
                }
            
        }
        }
        
    }
    func buttonTapped(_ number: Int) {
        if number == 0 { //if user taps Rock
            if shouldWin && computerAnswer == 2 || !shouldWin && computerAnswer == 1 {
                score += 1
            } else if shouldWin && computerAnswer == 1 || !shouldWin && computerAnswer == 2 {
                score -= 1
            } else {
                score += 0
            }
        }
        if number == 1 { //if user taps Paper
            if shouldWin && computerAnswer == 0 || !shouldWin && computerAnswer == 2 {
                score += 1
            } else if shouldWin && computerAnswer == 2 || !shouldWin && computerAnswer == 0 {
                score -= 1
            } else {
                score += 0
            }
        }
        if number == 2 { //if user taps Scissors
            if shouldWin && computerAnswer == 1 || !shouldWin && computerAnswer == 0 {
                score += 1
            } else if shouldWin && computerAnswer == 0 || !shouldWin && computerAnswer == 1 {
                score -= 1
            } else {
                score += 0
            }
        }
        promptUser()
    }
    func promptUser() {
        if gameCount == 10 {
            showingScore = true
            gameCount = -1
        }
        if gameCount == 0 {
            score = 0
        }
        computerAnswer = Int.random(in: 0...2)
        shouldWin = Bool.random()
        gameCount += 1
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
