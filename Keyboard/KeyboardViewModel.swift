//
//  KeyboardViewModel.swift
//  Keyboard
//
//  Created by Hilmy Veradin on 12/07/24.
//

import Foundation

enum SelectedLanguage: String, CaseIterable, Identifiable {
    case indonesia
    case english
    case chinese
    case spanish
    case germany
    case french
    case japanese
    case russian
    case portugese
    case hindi
    var id: Self { self }
}

final class KeyboardViewModel: ObservableObject {
    private let openAIService = OpenAIService()
    @Published var changedText = ""
    @Published var selectedText = ""
    @Published var isTextChanged = false
    @Published var isLoading = false
    @Published var destinationLanguage: SelectedLanguage = .english

    func translate() {
        isLoading = true
        openAIService.translate(text: selectedText, destination: destinationLanguage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(changedText):
                    self.changedText = changedText
                    self.isTextChanged = true
                    self.isLoading = false
                case .failure:
                    self.isLoading = false
                }
            }
        }
    }
    
    func fixGrammar() {
        isLoading = true
        openAIService.fixGrammar(text: selectedText, destination: destinationLanguage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(changedText):
                    self.changedText = changedText
                    self.isTextChanged = true
                    self.isLoading = false
                case .failure:
                    self.isLoading = false
                }
            }
        }
    }

    func resetStates() {
        changedText = ""
        isTextChanged = false
    }
}
