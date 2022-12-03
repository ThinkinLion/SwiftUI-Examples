//
//  bottomOfSafeArea.swift
//  examples
//
//  Created by 1100690 on 2022/12/02.
//

import SwiftUI

struct Message: Identifiable {
    let text: String
    let id: UUID = UUID()
}


struct bottomOfSafeArea: View {
    @State private var messages: [Message] = []
    @State private var newMessageText = ""
    
    var body: some View {
        NavigationStack {
            List(messages) { message in
                Text(message.text)
            }
            .safeAreaInset(edge: .bottom) {
                TextField("New message", text: $newMessageText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .background(.ultraThinMaterial)
                    .onSubmit {
                        if !newMessageText.isEmpty {
                            messages.append(Message(text: newMessageText))
                            newMessageText = ""
                        }
                    }
            }
            .listStyle(.plain)
            .navigationTitle("My messages")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            for i in 1...21 {
                messages.append(Message(text: "Message \(i)"))
            }
        }
    }
}

struct bottomOfSafeArea_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
