//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Andrew Garcia on 4/6/21.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 1)
        
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text("\(countries[correctAnswer])")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .modifier(FlagImage())
                    }
                }
                Spacer()
                Text("Score: \(currentScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("Your score is \(currentScore)"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
        
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong. Thats the flag of \(countries[number])."
            currentScore -= 1
        }
        
        showingScore = true
    
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
