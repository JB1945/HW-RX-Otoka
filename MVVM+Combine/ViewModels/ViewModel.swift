//
//  ViewModel.swift
//  MVVM+Combine
//
//  Created by Artur Yanchenko on 28.07.23.
//

import Foundation
import Combine

enum ViewStates {
    case loading
    case success
    case failed
}

class ViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var state: ViewStates?

    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email
            .map { $0.isEmail() }
            .eraseToAnyPublisher()
    }

    var isPasswordPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }

    var isLoginEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidEmailPublisher, isPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    func submitLogin() {
        state = .loading


        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            guard let self = self else {return}
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }

    func isCorrectLogin() -> Bool {
        return email == "test@mail.com" && password == "12345"
    }
}
