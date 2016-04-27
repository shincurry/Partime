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
    static var token: String? = {
        let keychain = Keychain(service: "com.windisco.Partime")
        return keychain["accessToken"]
    }()
    
    let baseUri = "http://www.aldjob.com/api"
    let imageBaseUri = "http://www.aldjob.com"
    
    
    // --- User --
    func getValidateCode(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/getValidateCode.do"
        
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func register(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/register.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func login(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/authorize.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // Profile
    
    func getProfile(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/get.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func updateProfile(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/update.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func updateAvatar(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/logoUpdate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
//    func getEmployeeProfile(params: [String: String], completion: Result<NSData, NSError> -> Void) {
//        let uri = "/user/profile/employee.do"
//        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
//    }
//    func updateEmployeeProfile(params: [String: String], completion: Result<NSData, NSError> -> Void) {
//        let uri = "/user/profile/employeeUpdate.do"
//        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
//    }
//    func getEmployerProfile(params: [String: String], completion: Result<NSData, NSError> -> Void) {
//        let uri = "/user/profile/employer.do"
//        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
//    }
//    func updateEmployerProfile(params: [String: String], completion: Result<NSData, NSError> -> Void) {
//        let uri = "/user/profile/employerUpdate.do"
//        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
//    }
    
    
    // ---- Personal / Enterprise Verification
    
    func verifyPersonal(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/personCertificate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func verifyEnterprise(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/enterpriseCertificate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    // -----
    func getCities(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/getCities.do"
        httpPostRequest(uri: "http://120.24.156.196/XXXX" + uri, parameters: params, completion: completion)
    }
    func getCountries(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/getCountries.do"
        httpPostRequest(uri: "http://120.24.156.196/XXXX" + uri, parameters: params, completion: completion)
    }
    
    
    // --- Part Time ---
    func getJobs(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/pt/getByTypeandPlace.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func getJobsCount(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
    let uri = "/pt/getCountByTypeandPlace.do"
    httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }

    func getJobDetails(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/pt/getDetail.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // ----- Employee Manager -----
    func requestAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employeeManage/Request.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getMyJobsCount(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employeeManage/getCountbyStatus.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getMyJobs(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employeeManage/getbyStatus.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func cancelAJobRequest(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employeeManage/cancelRequest.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // ----- Employer Manager -----
    
    func postAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employerManage/Post.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    
    private func httpPostRequest(uri uri: String, parameters: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        Alamofire.request(.POST, uri, parameters: parameters, encoding: .URL, headers: nil).responseData() { response in
            completion(response.result)
        }
    }
    
    func verifyPersonalNew(datas: [String: NSData], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/profile/personCertificate.do"
        uploadDatas(uri: baseUri + uri, datas: datas, completion: completion)
    }
    
    func uploadDatas(uri uri: String, datas: [String: NSData], completion: Result<NSData, NSError> -> Void) {
        Alamofire.upload(.POST, uri, multipartFormData: { parts in
            for data in datas {
                parts.appendBodyPart(data: data.1, name: data.0)
            }
            
            }, encodingCompletion: { encodingResult in
                
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseData() { response in
                    completion(response.result)
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    
    func getImageUrl(uri: String) -> NSURL {
        return NSURL(string: imageBaseUri + uri)!
    }
}
