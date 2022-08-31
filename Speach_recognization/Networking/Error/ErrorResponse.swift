//
//  ErrorResponse.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation

class ErrorResponse: Decodable {
    var status: String
    var error: ErrorModel
    
    enum CodingKeys: String,CodingKey {
        case status
        case error
    }
}
