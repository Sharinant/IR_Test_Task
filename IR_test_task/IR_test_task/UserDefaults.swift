//
//  UserDefaults.swift
//  IR_test_task
//
//  Created by Антон Шарин on 27.02.2023.
//

import Foundation

final class UserToken {
    static var userToken : String! {
        get {
            return UserDefaults.standard.string(forKey: "token")
        } set {
            let defaults = UserDefaults.standard
            if let token = newValue {
                defaults.set(token, forKey: "token")
            } else {
                defaults.removeObject(forKey: "token")
            }
        }
    }
}
