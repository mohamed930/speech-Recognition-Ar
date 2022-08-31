//
//  Groub.swift
//  Speach_recognization
//
//  Created by Mohamed Ali on 30/08/2022.
//

import Foundation

struct Group: Codable {
    let items: [GroupItem]
}

struct GroupItem: Codable {
    let venue: Venue
}

struct Venue: Codable {
    let id, name: String
    let location: Location
    let rating: Double
    let ratingColor: RatingColor
    let photos: Photos

    enum CodingKeys: String, CodingKey {
        case id, name, location, rating, ratingColor
        case photos
    }
}

enum RatingColor: String, Codable {
    case c5De35 = "C5DE35"
    case ffc800 = "FFC800"
    case the00B551 = "00B551"
    case the73Cf42 = "73CF42"
}

// MARK: - Location
struct Location: Codable {
    let address: String?
    let lat, lng: Double
}

// MARK: - Photos
struct Photos: Codable {
    let groups: [GroupImage]
}

struct GroupImage: Codable {
    let items: [GroupItemImage]
}

// MARK: - GroupItem
struct GroupItemImage: Codable {
    let itemPrefix: String?
    let suffix: String?

    enum CodingKeys: String, CodingKey {
        case itemPrefix = "prefix"
        case suffix
    }
}
