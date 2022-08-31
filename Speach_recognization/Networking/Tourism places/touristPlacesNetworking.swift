//
//  touristPlacesNetworking.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation
import Alamofire

enum touristPlacesNetworking {
    case getMuesumes
}


extension touristPlacesNetworking: TargetType {
    var baseURL: String {
        return baseurl
    }
    
    var path: String {
        return endpoint
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        let parameters = ["near": "Egypt", "venuePhotos": "1", "query": "museum", "oauth_token": authenticationKey, "v": version]
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding(destination: .queryString))
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
