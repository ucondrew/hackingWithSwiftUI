//
//  ContentView.swift
//  Edutainment
//
//  Created by Andrew Garcia on 5/7/21.
//

import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false
    @State private var minRange = 1
    @State private var maxRange = 12
    @State private var questions = ["5", "10", "20", "All"]
    @State private var selectedQuestion = 5
    
    @State private var answer = ""
    @State private var score = 0
    
    @State private var questionsArray = [Question]()
    @State private var currentQuestion = 0
    @State private var num1 = 2
    @State private var num2 = 12
    @State private var numOfQuestions = 0
    
    @State private var gameOver = false
    
    @State private var isCorrect = false
    @State private var rotationAmt = 0
    
    var body: some View {
        
        if gameStarted {
            NavigationView {
                VStack {
                    
                    Spacer()
                    TextField("Enter your answer", text: $answer)
                        .padding(15)
                        .multilineTextAlignment(.center)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(isCorrect ? Color.green : Color.red, lineWidth: 1))
                            .padding()
                        
                        .keyboardType(.numberPad)
                        .animation(.spring())
                    
                Section {
                    Button("Check Answer"){
                        self.checkAnswer()
                        self.loadCurrentQuestion()
                        self.answer = ""
                    }
                    
                        .padding(20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .clipShape(Capsule())
                        .animation(.spring())
                    Spacer()
                    Text("Score: \(score)/\(numOfQuestions) Total Questions: \(numOfQuestions)")
                    
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(isCorrect ? Color.green : Color.red, lineWidth: 3))
                            .padding()
                        .animation(.spring())
                        
                        
                    Spacer()
                    }
                }
                .navigationBarTitle(Text("What is \(num1) x \(num2)?"))
                .navigationBarItems(trailing:
                    Button("Settings") {
                        withAnimation {
                            self.gameStarted.toggle()
                        }
                        
                    }
                    
                        
                )
                .alert(isPresented: $gameOver, content: {
                    Alert(title: Text("Game Over"), message: Text("Your score was: \(score)/\(numOfQuestions)"), dismissButton: .default(Text("Continue")) {
                        withAnimation {
                        
                        self.gameStarted.toggle()
                        }
                        
                    })
                    
                })
            } .transition(.scale)
        } else {
            NavigationView {
                VStack {
                    Form {
                        Section(header: Text("How many questions?")) {
                            Picker(selection: $selectedQuestion, label: Text("how many questions")) {
                                ForEach(0..<questions.count) { number in
                                    Text("\(self.questions[number])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                            .padding(9)
                        }
                        Stepper(value: $minRange, in: 1...(maxRange - 1)) {
                            Text("Min range:  \(minRange)")
                        }
                        Stepper(value: $maxRange, in: (minRange + 1)...12) {
                            Text("Max range:  \(maxRange)")
                        }
                    }
                    
                    Button("Start game") {
                        withAnimation {
                            self.gameStarted.toggle()
                            self.loadQuestions()
                            self.loadCurrentQuestion()
                        }
                    }
                    .padding()
                    .font(.title2)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Spacer()
                    
                }
                .navigationBarTitle(Text("Multiplication Tables"))
            } .transition(.scale)
            
        }
    }
    func loadQuestions() {
        questionsArray = []
        score = 0
        
        currentQuestion = 0
        for num1 in minRange...maxRange {
            for num2 in minRange...maxRange {
                questionsArray.append(Question(num1: num1, num2: num2))
            }
            
        }
        questionsArray.shuffle()
        numOfQuestions = Int(questions[selectedQuestion]) ?? questionsArray.count
    }
    
    func loadCurrentQuestion() {
        if currentQuestion < numOfQuestions {
            let loadedQuestion = questionsArray[currentQuestion % questionsArray.count]
            num1 = loadedQuestion.num1
            num2 = loadedQuestion.num2
            currentQuestion += 1
        } else {
            gameOver = true
        }
    }
    
    func checkAnswer() {
        let correctAnswer = num1 * num2
        if Int(answer) == correctAnswer { //correct
            score += 1
            isCorrect = true
        } else {
            isCorrect = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Question {
    var num1: Int
    var num2: Int
}
