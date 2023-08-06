//
//  ViewController.swift
//  MVVM+Combine
//
//  Created by Artur Yanchenko on 28.07.23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet var loginField: UITextField!
    @IBOutlet var passField: UITextField!

    @IBOutlet weak var loginButton: UIButton!

     @IBOutlet var label: UILabel!

    
    var viewModel = ViewModel()
    var cancellables = Set<AnyCancellable>()

    func initialState() {
        label.isHidden = true
        label.text = ""
        label.textColor = .systemGray2

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
       initialState()
        
    }
    
    
    func bindViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: loginField)
            .map {($0.object as! UITextField).text ?? ""}
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passField)
            .map {($0.object as! UITextField).text ?? ""}
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)


        viewModel.isLoginEnabled
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)


        viewModel.$state
            .sink { [ weak self ] state in
                switch state {
                case .loading :

                    self?.label.isEnabled = true
                    self?.loginButton.isEnabled = false
                    self?.loginButton.setTitle("Loading...", for: .normal)
                case .success:
                    self?.label.isHidden =  false
                    self?.label.text = "Login success!"
                    self?.label.textColor = .systemGreen
                    self?.loginButton.setTitle("Login", for: .normal)
                case .failed:
                    self?.label.isHidden =  false
                    self?.label.text = "Login failed!"
                    self?.label.textColor = .systemRed
                    self?.loginButton.setTitle("Login", for: .normal)
                case .none:
                    break
                }
            }
            .store(in: &cancellables)


    }



    @IBAction func loginButtonPressed(_sender: Any) {
        viewModel.submitLogin()
    }
}
