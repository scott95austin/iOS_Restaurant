//
//  Models.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/27/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import Foundation
import CoreLocation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageURL: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let id: String
    let name: String
    let imageURL: URL
    let distance: Double
    
    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }
    var formattedDistance: String? {
        return RestaurantListViewModel.numberFormatter.string(from: distance as NSNumber)
    }
}

extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.id = business.id
        self.imageURL = business.imageURL
        self.distance = business.distance / 1609.344
    }
}

struct Details: Decodable {
    let price: String
    let phone: String
    let isClosed: Bool
    let rating: Double
    let name: String
    let photos: [URL]
    let coordinates: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: CodingKey
    {
        case latitude
        case longitude
        
    }
    public init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

struct DetailsViewModel {
    let name: String
    let price: String
    let isOpen: String
    let phoneNumber: String
    let rating: String
    let imageURL: [URL]
    let coordinates: CLLocationCoordinate2D
}

extension DetailsViewModel {
    init(details: Details) {
        self.name = details.name
        self.price = details.price
        self.isOpen = details.isClosed ? "Closed" : "Open"
        self.phoneNumber = details.phone
        self.rating = "\(details.rating) / 5.0"
        self.imageURL = details.photos
        self.coordinates = details.coordinates
    }
}


