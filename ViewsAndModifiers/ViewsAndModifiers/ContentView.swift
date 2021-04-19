//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Andrew Garcia on 4/8/21.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .padding()
            .foregroundColor(.blue)
            
            
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}
struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}



struct ContentView: View {
    
    var body: some View {
        Text("Hello world")
            .titleStyle()
            
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
