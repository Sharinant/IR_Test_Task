//
//  ViewController.swift
//  IR_test_task
//
//  Created by Антон Шарин on 26.02.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var captchaImageView: UIImageView!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var captchaTextField: UITextField!
   
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.checkToken()
        viewModel.getCaptcha()
        viewModel.delegate = self
        loginTextField.delegate = self
        passwordTextField.delegate = self
        captchaTextField.delegate = self
        
    }

    @IBAction func loginAction(_ sender: Any) {
        if loginTextField.text == "" || passwordTextField.text == "" || captchaTextField.text == "" {
            return
        } else {
            viewModel.login(with: loginTextField.text!, password: passwordTextField.text!, captcha: captchaTextField.text!)
            loginTextField.text = ""
            passwordTextField.text = ""
            captchaTextField.text = ""
        }
    }
    
}

extension ViewController : viewModelToView {
    
    func showAlert(for error: String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Внимание", message: "Проблема - \(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func goToDetails(with name: String) {
        DispatchQueue.main.async {
            let vc = DetailsViewController()
            vc.nameForLabel = name
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.captchaImageView.image = self.viewModel.giveImage()
        }
    }
    
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        captchaTextField.resignFirstResponder()
        return true
    }
}
