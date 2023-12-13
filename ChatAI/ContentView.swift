//
//  ContentView.swift
//  ChatAI
//
//  Created by Mindrescu Dragomir on 13.12.2023.
//

import OpenAISwift
import SwiftUI

final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
            let config = OpenAISwift.Config.makeDefaultOpenAI(apiKey: "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")
            self.client = OpenAISwift(config: config)
        }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 500,  completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
                
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
