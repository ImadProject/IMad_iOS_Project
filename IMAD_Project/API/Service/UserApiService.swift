//
//  UserApiService.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/16.
//

import Foundation
import Alamofire
import Combine

enum UserApiService{
    
    static var intercept = BaseIntercept()
    
    static func user() -> AnyPublisher<NetworkResponse<UserResponse>,AFError>{
        print("유저정보 api 호출")
        return ApiClient.shared.session
            .request(UserRouter.user,interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<UserResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func otheruUser(id:Int) -> AnyPublisher<NetworkResponse<ProfileResponse>,AFError>{
        print("다른 유저정보 api 호출")
        return ApiClient.shared.session
            .request(UserRouter.otherUser(id: id),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type:NetworkResponse<ProfileResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    
    static func patchUser(gender:String?,birthYear:Int?,nickname:String,tvGenre:[Int]?,movieGenre:[Int]?) -> AnyPublisher<NetworkResponse<UserResponse>,AFError>{
        print("유저정보변경 api 호출")
        return ApiClient.shared.session
            .request(UserRouter.patchUser(gender: gender, birthYear: birthYear, nickname: nickname, tvGenre: tvGenre,movieGenre: movieGenre),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<UserResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func passwordChange(old:String,new:String)-> AnyPublisher<NetworkResponse<Int>,AFError>{
        print("비밀번호변경 api 호출")
        return ApiClient.shared.session
            .request(UserRouter.passwordChange(old: old, new: new),interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<Int>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
    static func getProfile() -> AnyPublisher<NetworkResponse<ProfileResponse>,AFError>{
        print("프로필 요청 정보 api 호출")
        return ApiClient.shared.session
            .request(UserRouter.profile,interceptor: intercept)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: NetworkResponse<ProfileResponse>.self)
            .value()
            .map{ receivedValue in
                print("결과 메세지  : \(receivedValue.message)")
                return receivedValue.self
            }
            .eraseToAnyPublisher()
    }
}
