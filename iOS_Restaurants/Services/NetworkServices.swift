//
//  NetworkServices.swift
//  iOS_Restaurants
//
//  Created by Austin Scott on 3/26/20.
//  Copyright © 2020 Austin Scott. All rights reserved.
//

import Foundation
import Moya

private let apiKey = "q5wulR_e-MyZODL2S5-pDaHKyEJXtV15tsNfzhRL8zIih7o1rCjggJHxjVjraSJYRbNHetTbbNzMNkPtXuTfj9z1wKbKa_5lWAfcTpgd-cHlc2XpN22HoqsLpxJ9XnYx"

enum YelpServices
{
    enum BusinessProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)
        
        var baseURL: URL
        {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String
        {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }
        
        var method: Moya.Method
        {
            return .get
        }
        
        var sampleData: Data
        {
            return Data()
        }
        
        var task: Task
        {
            switch self {
            case let .search(lat, long):
                return .requestParameters(
                    parameters: ["latitude": lat, "longitude": long, "limit": 10],
                    encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
        }
        
        var headers: [String : String]?
        {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
