//
//  AuthApiService.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/06.
//

import Foundation
import Alamofire
import Combine

enum AuthApiService{
    
    static let intercept = BaseIntercept()
    
    static func login(email:String,password:String) -> AnyPublisher<GetUserInfo,AFError>{
        print("로그인 api 호출")
        return ApiClient.shared.session
            .request(AuthRouter.login(email: email, password: password))
            .response{ response in
                if let accessToken = response.response?.allHeaderFields["Authorization"] as? String,let refreshToken = response.response?.allHeaderFields["Authorization-refresh"] as? String{
                    UserDefaultManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
                }
            }
            .publishDecodable(type: GetUserInfo.self)
            .value()
            .eraseToAnyPublisher()
    }
    static func register(email:String,password:String,authProvider:String) -> AnyPublisher<RegisterResponse,AFError>{
        print("회원가입 api 호출")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(email: email, password: password,authProvider:authProvider))
            .response{ response in
                if let accessToken = response.response?.allHeaderFields["Authorization"] as? String,let refreshToken = response.response?.allHeaderFields["Authorization-refresh"] as? String{
                    UserDefaultManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
                }
            }
            .publishDecodable(type: RegisterResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
    static func delete() -> AnyPublisher<GetUserInfo,AFError>{
        print("회원탈퇴 api 호출")
        return ApiClient.shared.session
            .request(AuthRouter.delete,interceptor: intercept)
            .publishDecodable(type: GetUserInfo.self)
            .value()
            .eraseToAnyPublisher()
    }

}

