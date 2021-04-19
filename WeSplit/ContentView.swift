//
//  ContentView.swift
//  WeSplit
//
//  Created by Andrew Garcia on 4/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""  //@State because values change during one instance of view
    @State private var numberOfPeople = "2"
    @State private var tipPercentage = 2
    
    var useRedText: Bool { if tipPercentage == 4 { //computed var that controls red text for total check amount
        return true } else {
            return false
        }
    
    }
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(Int(numberOfPeople) ?? 2 + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    var grandTotal: Double {
        let people = Double(Int(numberOfPeople) ?? 2 + 2)
        let total = totalPerPerson * people
        return total
    }
    
    var body: some View {
        NavigationView { //This creates the navigation bar
            Form { //creates form in the view
                Section { //adds a section including a textfield for user input and a picker
                    TextField("Check Amount", text: $checkAmount) //$ two way binds variable to be updated
                        .keyboardType(.decimalPad) //keypad instead of keyboard
                    TextField("Number of People", text: $numberOfPeople) //another textfield for # of ppl
                        .keyboardType(.numberPad) //numberpad for integers only
                }
                Section(header: Text("Tip Percentage")) { //second section which contains a title
                    
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) { //loops through however many percentages there are
                            Text("\(self.tipPercentages[$0])%") //displays item in array
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) //changed from default picker to horizontal tab picker
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section(header: Text("Total check amount")) {
                    Text("$\(grandTotal, specifier: "%.2f")")
                        .foregroundColor(useRedText ? .red : .black) //ternary operator to control color of text
                }
                
                
            }
            .navigationBarTitle("Check Total With Tip") //title of the form
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
