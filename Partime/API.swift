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
    
    let baseUri = ""
    let imageBaseUri = ""
    
    
    // --- User --
    func getValidateCode(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/getValidateCode.do"
        
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func register(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/register.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func login(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/authorize.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func forgotPassword(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/passwordForgot.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // Profile
    
    func getProfile(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/get.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func updateProfile(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/update.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func updateAvatar(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/logoUpdate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // ---- Personal / Enterprise Verification
    
    func verifyPersonal(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/personCertificate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func verifyEnterprise(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/enterpriseCertificate.do"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    // -----
    func getCities(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/getCities.do"
        httpPostRequest(uri: "http://120.24.156.196/XXXX" + uri, parameters: params, completion: completion)
    }
    func getCountries(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/getCountries.do"
        httpPostRequest(uri: "http://120.24.156.196/XXXX" + uri, parameters: params, completion: completion)
    }
    
    
    // --- Part Time ---
    func getJobs(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/pt/get"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func getJobsCount(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/pt/count"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }

    func getJobDetails(_ jobID: Int, completion: @escaping (Result<Data>) -> Void) {
        let uri = "/pt/\(jobID)"
        httpGetRequest(uri: baseUri + uri, parameters: [:], completion: completion)
    }
    
    // ----- Employee Manager -----
    func requestAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employee/request"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployeeJobsCount(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employee/byStatusCount"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployeeJobs(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employee/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func cancelAJobRequest(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employee/cancelRequest"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    // ----- Employer Manager -----
    
    func postAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/post/post"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func startAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/post/start"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func endAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/applying/end"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func deleteAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/post/delete"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployerJobsCount(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/byStatusCount"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getEmployerJobs(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getJobsHireMembers(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/applying/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func getJobsWorkingMembers(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/working/byStatus"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func dealRequest(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/applying/passOrFail"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    func dealWorking(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/working/yesOrNo"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    func getEmployeeProfile(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/userDetail"
        httpGetRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    func finishAJob(_ params: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/employer/working/end"
        httpPostRequest(uri: baseUri + uri, parameters: params, completion: completion)
    }
    
    
    
    fileprivate func httpPostRequest(uri: String, parameters: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        Alamofire.request(uri, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData() { response in
            completion(response.result)
        }    }
    fileprivate func httpGetRequest(uri: String, parameters: [String: AnyObject], completion: @escaping (Result<Data>) -> Void) {
        Alamofire.request(uri, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData() { response in
            completion(response.result)
        }
    }
    fileprivate func httpGetRequest(uri: String, completion: @escaping (Result<Data>) -> Void) {
        Alamofire.request(uri, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseData() { response in
            completion(response.result)
        }
    }
    
    
    func verifyPersonalNew(_ datas: [String: Data], completion: @escaping (Result<Data>) -> Void) {
        let uri = "/user/profile/personCertificate.do"
        uploadDatas(uri: baseUri + uri, datas: datas, completion: completion)
    }
    
    func uploadDatas(uri: String, datas: [String: Data], completion: @escaping (Result<Data>) -> Void) {
        Alamofire.upload(multipartFormData: { parts in
            for data in datas {
                parts.append(data.value, withName: data.key)
            }
            
        }, to: uri, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData() { response in
                    completion(response.result)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    
    func getImageUrl(_ uri: String) -> URL {
        return URL(string: imageBaseUri + uri)!
    }
    
    
    func getAds(_ completion: @escaping (Result<Data>) -> Void) {
        let uri = "/app/ad"
        httpGetRequest(uri: baseUri + uri, completion: completion)
    }
}
