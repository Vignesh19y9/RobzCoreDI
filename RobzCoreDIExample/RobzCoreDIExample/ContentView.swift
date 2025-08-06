//
//  ContentView.swift
//  RobzCoreDIExample
//
//  Created by Vignesh V on 06/08/25.
//

import SwiftUI
import RobzCoreDI
import RobzCoreDIMacro

struct ContentView: View {
    @Dependency(\.someValue) var someValue
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(someValue)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

@DependencyContainer
extension DependencyValues {
    var someValue: String = "Test"
}
