//
//  UserDefaultManager.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/13.
//

import Foundation
import Alamofire

class TokenManager{
  
    static let shared = TokenManager()    //싱글톤
    
    enum Key:String,CaseIterable{
        case refreshToken,accessToken
    }
    
    func clearAll(){    //데이터 전체 삭제
        Key.allCases.forEach{UserDefaults.standard.removeObject(forKey: $0.rawValue)}
    }
    func setToken(accessToken:String,refreshToken:String){  //토큰 저장
        UserDefaults.standard.set(accessToken, forKey: Key.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: Key.refreshToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    func getToken()->Token{
        let accessToken = UserDefaults.standard.string(forKey: Key.accessToken.rawValue) ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: Key.refreshToken.rawValue) ?? ""
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func checkToken(response:HTTPURLResponse?) -> Bool{
        var accessToken = ""
        var refreshToken = ""
        
        if let access = response?.allHeaderFields["Authorization"] as? String{
            accessToken = access
        }
        if let refresh = response?.allHeaderFields["Authorization-refresh"] as? String{
            refreshToken = refresh
        }else if let refresh = response?.allHeaderFields["authorization-refresh"] as? String{
            refreshToken = refresh
        }
        
        if !accessToken.isEmpty,!refreshToken.isEmpty{
            TokenManager.shared.setToken(accessToken: accessToken, refreshToken: refreshToken)
            return true     //토큰저장 성공했으니 받은 토큰으로 정보 재요청
        }else{
            return false    //토큰 저장 실패했으니 요청을 멈추고 초기화면으로 돌아감
        }
    }
}
