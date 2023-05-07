//
//  ApiClient.swift
//  IMAD_Project
//
//  Created by 유영웅 on 2023/05/06.
//

import Foundation
import Alamofire

final class ApiClient{
    
    var session:Session
    static let shared = ApiClient()
    static let baseURL = "https://imad-app.herokuapp.com/"
    let monitors = [ApiLogger()] as [EventMonitor]
    
    init(){
        session = Session(eventMonitors: monitors)
    }
    
}
