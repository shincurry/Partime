//
//  API.swift
//  Partime
//
//  Created by ShinCurry on 16/4/2.
//  Copyright © 2016年 ShinCurry. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainAccess

class API: NSObject {
    static let shared = API()
    static let token: String? = {
        let keychain = Keychain(service: "com.windisco.Partime")
        return keychain["accessToken"]
    }()
    
    let baseUri = "http://120.24.156.196/XXXX/api"
    
    func getValidateCode(params: [String: String], completion: (NSError?, JSON?) -> Void) {
        let uri = "/user/getValidateCode.do"
        
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func register(params: [String: String], completion: (NSError?, JSON?) -> Void) {
        let uri = "/user/register.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func login(params: [String: String], completion: (NSError?, JSON?) -> Void) {
        let uri = "/user/authorize.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    private func httpPostRequest(uri uri: String, parameters: [String: String], completion: (NSError?, JSON?) -> Void) {
        Alamofire.request(.POST, uri, parameters: parameters, encoding: .URL, headers: nil).responseData() { response in
            if response.result.isSuccess {
                completion(nil, JSON(data: response.result.value!))
            } else {
                completion(response.result.error, nil)
            }
            
        }
    }
}
