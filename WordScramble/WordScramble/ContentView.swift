//
//  ContentView.swift
//  WordScramble
//
//  Created by Andrew Garcia on 4/22/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var showingError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .padding([.horizontal, .bottom], 20)
                    .padding(.top, -10)
                    
                    .textFieldStyle(RoundedBorderTextFieldStyle()) //form-like cell
                    .autocapitalization(.none)
                
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                    
                }
                Text("\(score) points")
                    .font(.headline)
                    .padding(2)
            }
            //.navigationBarTitle(rootWord)
            .navigationBarItems(leading: Text(rootWord).font(.largeTitle), trailing: Button(action: startGame) {
                Image(systemName: "arrow.triangle.2.circlepath")
            }) .padding(0)
            
            
            .onAppear(perform: startGame)// calls startGame() each time navigationView is loaded
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
                
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //guard lets us trap invalid parameters passed into the methods. Any condition you would have checked using if can be checked using guard.
        
        guard answer.count > 0 else { //if remaining string is empty, exit method
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word already used", message: "Be more original.")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up.")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        score += answer.count
        newWord = ""
    }
    
    func startGame() {
        //1. Find the start.txt URL in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                //3. split the string into an array of strings by linebreak
                let allWords = startWords.components(separatedBy: "\n")
                //4. pick a random word in the array
                rootWord = allWords.randomElement() ?? "astraphobia"
                usedWords = [String]()
                score = 0
                newWord = ""
                //5. everything worked!
                return
            }
        }
        //there was a problem loading start.txt
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word) //can omit return
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        if word.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
