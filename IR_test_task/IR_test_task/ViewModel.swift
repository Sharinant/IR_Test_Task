//
//  ViewModel.swift
//  IR_test_task
//
//  Created by Антон Шарин on 26.02.2023.
//

import Foundation
import UIKit

protocol viewModelToView : AnyObject {
    func updateView()
    func goToDetails(with name : String)
    func showAlert(for error: String)
}


class HomeViewModel {
    
    weak var delegate : viewModelToView?
    
    let caller = ApiCaller()
    
    var captcha : Captcha?
    var authResponse : AuthResponse?
    var captchaImage : UIImage?
    
    var token : String? 
    
    func checkToken() {
        
        if UserDefaults.standard.object(forKey: "token") != nil {
            self.caller.getDetailInformation(with: UserDefaults.standard.object(forKey: "token") as! String) { result in
                switch result {
                case .success(let result):
                    self.delegate?.goToDetails(with: result.data.profile.name)
                case .failure(let error) :
                    print(error)
                }
            }
        }
           
        
    }
    
    func getCaptcha() {
        caller.getCaptcha { result in
            switch result {
            case .success(let data) :
                self.captcha = data
                self.captchaImage = self.decodeImage(data: data)
                self.delegate?.updateView()
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
    private func decodeImage(data : Captcha) -> UIImage {
        let newImageData = Data(base64Encoded: modifyString(string: data.data.image_data))!
        
        if let image = UIImage(data: newImageData) {
            return image

        } else {return UIImage()}
    }
    
    
    private func modifyString(string:String) -> String {
        var newString = string
        newString.removeFirst(22)
        return newString
    }
    
    func giveImage() -> UIImage {
        return captchaImage ?? UIImage()
    }
    
    func login(with login: String, password : String, captcha : String) {
        let user = AuthUser(username: login, password: password, captcha: CaptchaAuth(key: (self.captcha?.data.key)!, value: captcha))
        caller.auth(with: user) { result in
            switch result {
            case .success(let result) :
                UserToken.userToken = result.data?.accessToken!
                self.caller.getDetailInformation(with: (result.data?.accessToken)!) { result in
                    switch result {
                    case .success(let result):
                        self.delegate?.goToDetails(with: result.data.profile.name)
                    case .failure(let error) :
                        print(error)
                    }
                }
            case .failure(let error) :
                if error == .login {
                    self.delegate?.showAlert(for: "Логин / Пароль")

                }
                if error == .json {
                    self.delegate?.showAlert(for: "Капча")

                }
            }
        }
    }
}
