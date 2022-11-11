//
//  HomeModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

struct OfficeResource: Codable {
    let content: [Office]
    
    init() {
        self.content = []
    }

    enum CodingKeys: String, CodingKey {
        case content = "context"
    }
}

struct Office: Codable {
    let officeName: String
    let regionName: String
    let imageURL: String
    let introduceURL: String
    let galleryURL: String
    let latitude: Double
    let longitude: Double
    let spots: [Spot]
    
    enum CodingKeys: String, CodingKey {
        case officeName = "officename"
        case regionName = "regionname"
        case imageURL = "imageurl"
        case introduceURL = "introduceurl"
        case galleryURL = "galleryurl"
        case latitude, longitude, spots
    }
}

struct Spot: Codable {
    let title: String
    let latitude: Double
    let longitude: Double
    let type: String
    
    var spotType: SpotType {
        switch self.type {
        case "cafe":
            return .cafe
        case "nature":
            return .nature
        case "restaurant":
            return .restaurant
        default:
            return .cafe
        }
    }
}

enum SpotType: String {
    case cafe
    case nature
    case restaurant
    case sea
}

struct MagazineResource: Codable {
    let content: [Magazine]
    
    init() {
        self.content = []
    }
}

struct Magazine: Codable {
    let title: String
    let imageURL: String
    let introduceURL: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "imageurl"
        case introduceURL = "introduceurl"
    }
}
