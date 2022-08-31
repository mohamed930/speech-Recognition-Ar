//
//  ErrorModel.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation

class ErrorModel: Decodable {
    var message:String
    
    enum CodingKeys: String,CodingKey {
        case message
    }
}
