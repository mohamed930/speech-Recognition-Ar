//
//  touristPlacesAPI.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation

protocol touristPlacesAPIProtocol {
    func GetAllMuseumsOperation(completion: @escaping (Result<touristPlacesResponse?,NSError>) -> Void)
}

class touristPlacesAPI: BaseAPI<touristPlacesNetworking> {
    
    func GetAllMuseumsOperation(completion: @escaping (Result<touristPlacesResponse?,NSError>) -> Void) {
        
        self.fetchData(Target: .getMuesumes, ClassName: touristPlacesResponse.self) { response in
            completion(response)
        }
        
    }
}
