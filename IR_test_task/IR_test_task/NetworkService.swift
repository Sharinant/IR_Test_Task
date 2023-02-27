//
//  NetworkService.swift
//  IR_test_task
//
//  Created by Антон Шарин on 26.02.2023.
//

import Foundation

class ApiCaller {
    
    func getCaptcha(completion : @escaping (Result<Captcha,Error>) -> Void) {
        let url = URL(string: "https://api-events.pfdo.ru/v1/captcha")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error - \(error)")
                    completion(.failure(error))
                }
         
                if let data = data{
                    do {
                        let decoded = try JSONDecoder().decode(Captcha.self, from: data)
                        completion(.success(decoded))
                    }
                    catch {
                        completion(.failure(error))
                    }
                }
        }
        task.resume()
    }
    
    
    enum errors : Error {
        case json
        case login
        case network
    }
    
    func auth(with user : AuthUser,completion : @escaping (Result<AuthResponse,errors>) -> Void) {
        
        let jsondata = try? JSONEncoder().encode(user)

        let url = URL(string: "https://api-events.pfdo.ru/v1/auth")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsondata
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}

            do{
                let decoded = try JSONDecoder().decode(AuthResponse.self, from: data)
                switch decoded.resultCode {
                case "RES05" :
                    completion(.failure(errors.login))

                case "FLSCS" :
                    completion(.success(decoded))
                default:
                    break

                }
          
            
            }catch let jsn{
                print(jsn
                )
                completion(.failure(errors.json))
           }

     
    }
    task.resume()
    }
    
    func getDetailInformation(with token : String,completion : @escaping (Result<Details,Error>) -> Void) {

        let url = URL(string: "https://api-events.pfdo.ru/v1/user")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer " + token, forHTTPHeaderField: "authorization")
        
     //   request.setValue("application/json", forHTTPHeaderField: "Accept")
     //   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}

            do{
                let decoded = try JSONDecoder().decode(Details.self, from: data)
                print(decoded.data.profile.name)
                completion(.success(decoded))
                
            }catch {
                completion(.failure(error))
           }

     
    }
    task.resume()
    }
    
}
