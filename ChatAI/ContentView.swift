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
        //change the apiKey with your key
            let config = OpenAISwift.Config.makeDefaultOpenAI(apiKey: "tokem")
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
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models, id: \.self) { string in
                Text(string)
            }
            Spacer()
            HStack {
                TextField("Text here the message", text: $text)
                Button("Send"){
                   send()
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: " + response)
                self.text = ""
            }
        }
    }
}

#Preview {
    ContentView()
}
