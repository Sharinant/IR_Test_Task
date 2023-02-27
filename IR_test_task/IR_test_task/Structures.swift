//
//  Model.swift
//  IR_test_task
//
//  Created by Антон Шарин on 26.02.2023.
//

import Foundation

// MARK: - Get Captcha

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


// MARK: - Auth Request
struct AuthUser: Codable {
    let username : String
    let password : String
    let captcha : CaptchaAuth
}

struct CaptchaAuth: Codable {
    let key : String
    let value: String
}



// MARK: - AuthResponse
struct AuthResponse: Codable {
    let resultCode, resultMessage: String?
    var data: DataClass?

    enum CodingKeys: String, CodingKey {
        case resultCode = "result_code"
        case resultMessage = "result_message"
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resultCode = try container.decode(String.self, forKey: .resultCode)
        self.resultMessage = try container.decode(String.self, forKey: .resultMessage)
        if let data = try container.decode(DataClass?.self, forKey: .data) {
            self.data = data

        } else if ((try container.decode([DataClass]?.self, forKey: .data)) != nil) {
            self.data = nil
        }
    }
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

// MARK: - Details Response
struct Details: Codable {
    let resultCode, resultMessage: String
    let data: Info

    enum CodingKeys: String, CodingKey {
        case resultCode = "result_code"
        case resultMessage = "result_message"
        case data
    }
}

// MARK: - Info
struct Info: Codable {
    let id: Int
    let username, createdAt: String
    let status: Int
    let isPfdoUser: Bool?
    let roles: [Municipality]
    let organizer: String?
    let profile: Profile
    let region, department, member, certificate: String?
    let social: [Social]
    let timezone: String
    let activeSystem: Int

    enum CodingKeys: String, CodingKey {
        case id
        case username = "username"
        case createdAt = "created_at"
        case status
        case isPfdoUser
        case roles, organizer, profile, region, department, member, certificate, social, timezone
        case activeSystem = "active_system"
    }
}

// MARK: - Profile
struct Profile: Codable {
    let email: String
    let phone: String?
    let birthdayAt, caption, firstName, middleName: String
    let lastName, emailVerifiedAt, name: String
    let region, municipality: Municipality
    let avatar: Avatar
    let address: String?

    enum CodingKeys: String, CodingKey {
        case email, phone
        case birthdayAt = "birthday_at"
        case caption
        case firstName = "first_name"
        case middleName = "middle_name"
        case lastName = "last_name"
        case emailVerifiedAt = "email_verified_at"
        case name, region, municipality, avatar, address
    }
}

// MARK: - Avatar
struct Avatar: Codable {
    let id: Int
    let url, thumb: String
}

// MARK: - Municipality
struct Municipality: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
    }
}

// MARK: - Social
struct Social: Codable {
    let id, type, socialID: Int

    enum CodingKeys: String, CodingKey {
        case id, type
        case socialID = "social_id"
    }
}

