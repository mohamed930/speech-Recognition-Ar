//
//  ResponseClass.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation

// MARK: - ResponseClass
struct ResponseClass: Codable {
    let geocode: Geocode
    let groups: [Group]
}

struct Geocode: Codable {
    let center: Center
}

// MARK: - Center
struct Center: Codable {
    let lat, lng: Double
}
