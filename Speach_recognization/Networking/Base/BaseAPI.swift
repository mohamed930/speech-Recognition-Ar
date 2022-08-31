//
//  BaseAPI.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation
import Alamofire

class BaseAPI<T:TargetType> {
    
    func fetchData<M:Decodable> (Target:T, ClassName:M.Type, completion:@escaping (Result<M?,NSError>) -> ()) {
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)
        
        AF.request((Target.baseURL + Target.path), method: method, parameters: params.0, encoding: params.1, headers: headers).responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                completion(.failure(NSError()))
                return
            }
            
            if statusCode == 200 || statusCode == 201 {
                
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                    completion(.failure(error))
                    return
                }
                
                completion(.success(responseObj))
                
            }
            else {
                // ADD Custom Error
                
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let theJSONData =  try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    completion(.failure(error))
                    return
                }
                
                guard let responseObj = try? JSONDecoder().decode(ErrorResponse.self , from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message])
                    completion(.failure(error))
                    return
                }
                
                if responseObj.status == "-1" {
                    ErrorMessage.ResponseMessgae = responseObj.error.message
                    let error = NSError(domain: Target.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.ResponseMessgae!])
                    completion(.failure(error))
                }
            }
            
        }
    }
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
    
}
