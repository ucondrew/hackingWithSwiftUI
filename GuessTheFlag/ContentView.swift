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
    @State private var spin = 0.0
    @State private var animateCorrect = false
    @State private var animateWrong = false
    @State private var dragAmount = CGSize.zero
    
    
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
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? spin : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .opacity(number != self.correctAnswer && self.animateCorrect ? 0.25 : 1)
                    .overlay(
                        Capsule()
                            .fill(Color.red)
                            .opacity(number != self.correctAnswer && animateWrong ? 0.8 : 0)
                    )
                    
                        
                    
                    
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
                }
                )}
            
            
        }
        
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
            spin = 0
            
            
            withAnimation(.interpolatingSpring(stiffness: 10, damping: 7)) {
                self.spin = 360
                self.animateCorrect = true
            }
            
        } else {
            scoreTitle = "Wrong. Thats the flag of \(countries[number])."
            currentScore -= 1
            
            withAnimation(.interpolatingSpring(stiffness: 30, damping: 1)) {
                self.animateWrong = true
            }
        }
        
        showingScore = true
    
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animateCorrect = false
        animateWrong = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
