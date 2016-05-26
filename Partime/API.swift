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
    func forgotPassword(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/user/passwordForgot.do"
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
        let uri = "/pt/get"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func getJobsCount(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/pt/count"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }

    func getJobDetails(jobID: Int, completion: Result<NSData, NSError> -> Void) {
        let uri = "/pt/\(jobID)"
        httpGetRequest(uri: baseUri + uri, parameters: [:], completion: completion)
    }
    
    // ----- Employee Manager -----
    func requestAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employee/request"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployeeJobsCount(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employee/byStatusCount"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployeeJobs(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employee/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func cancelAJobRequest(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employee/cancelRequest"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // ----- Employer Manager -----
    
    func postAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/post"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func startAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/start"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func endAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/end"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func deleteAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/delete"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployerJobsCount(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/byStatusCount"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployerJobs(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getJobsHireMembers(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/applying/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getJobsWorkingMembers(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/working/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func dealRequest(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/applying/passOrFail"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func dealWorking(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/working/yesOrNo"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func getEmployeeProfile(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/userDetail"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    func finishAJob(params: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        let uri = "/employer/working/end"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    
    private func httpPostRequest(uri uri: String, parameters: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        Alamofire.request(.POST, uri, parameters: parameters, encoding: .URL, headers: nil).responseData() { response in
            completion(response.result)
        }
    }
    private func httpGetRequest(uri uri: String, parameters: [String: AnyObject], completion: Result<NSData, NSError> -> Void) {
        Alamofire.request(.GET, uri, parameters: parameters, encoding: .URL, headers: nil).responseData() { response in
            completion(response.result)
        }
    }
    private func httpGetRequest(uri uri: String, completion: Result<NSData, NSError> -> Void) {
        Alamofire.request(.GET, uri, parameters: nil, encoding: .URL, headers: nil).responseData() { response in
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
    
    
    func getAds(completion: Result<NSData, NSError> -> Void) {
        let uri = "/app/ad"
        httpGetRequest(uri: baseUri + uri, completion: completion)
    }
}
