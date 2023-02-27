import UIKit

var greeting = "Hello, playground"

struct Captcha : Codable {
    var result_code : String
    var result_message : String
    var data : dataCaptcha
    
    enum codingKeys : String,CodingKey {
        
        case result_code = "result_code"
        case result_message = "result_message"
        case data
    }
    
}

struct dataCaptcha : Codable {
    var key : String
    var image_data : String
    
    enum codingKeys : String,CodingKey {
        case key = "key"
        case image_data = "image_data"
    }
}

struct Auth: Codable {
    let username : String
    let password : String
    let captcha : CaptchaAuth
    
    enum codingKeys : String,CodingKey {
        case username = "username"
        case password = "password"
        case captcha
    }
}

// MARK: - Captcha Auth
struct CaptchaAuth: Codable {
    let key : String
    let value: String
    enum codingKeys : String,CodingKey {
        case key = "key"
        case value = "value"
    }
}




struct AuthResponse: Codable {
    let resultCode, resultMessage: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case resultCode = "result_code"
        case resultMessage = "result_message"
        case data
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.resultCode = try container.decode(String.self, forKey: .resultCode)
//        self.resultMessage = try container.decode(String.self, forKey: .resultMessage)
//        if let data = try container.decode(DataClass?.self, forKey: .data) {
//            self.data = data
//
//        }
//    }
}

struct DataClass: Codable {
    let tokenType: String?
    let expiresIn: Int?
    let accessToken, refreshToken: String?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case message = "message"
    }
}
let item = Auth(username: "qwer12", password: "password", captcha: CaptchaAuth(key: "o06OcA1MzAxNi40OD", value: ""))

let jsondata = try JSONEncoder().encode(item)


let url = URL(string: "https://api-events.pfdo.ru/v1/auth")
guard let requestUrl = url else { fatalError() }

var request = URLRequest(url: requestUrl)
request.httpMethod = "POST"

// Set HTTP Request Header
request.setValue("application/json", forHTTPHeaderField: "Accept")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")


let jsonData = try JSONEncoder().encode(item)

request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        if let error = error {
            print("Error took place \(error)")
            return
        }
        guard let data = data else {return}

        do{
            let todoItemModel = try JSONDecoder().decode(AuthResponse.self, from: data)
            print(todoItemModel)
        
        }catch let jsonErr{
            print(jsonErr)
       }

 
}
task.resume()
