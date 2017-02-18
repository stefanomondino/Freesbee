//
//  TVMaze.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//


import Foundation
import Moya


enum TVMaze {
    case search(String)
    case detail(identifier:String)
    case schedule(country:String?, date:Date?)
    case image(URL)
}

extension TVMaze : TargetType {
    public var task: Task {
        return .request
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var sampleData: Data {
        switch self {
            
        case .detail :
            return try! NSData(contentsOfFile: Bundle.main.path(forResource: "Show", ofType: "json")!) as Data
        case .image:
            return "".data(using: String.Encoding.utf8)!
        default:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    public var baseURL: URL {
        switch self {
        case .image(let url) :
            
            return URL(string:(url.scheme! + "://" + url.host!))!
            
        default:
            return URL(string: "https://api.tvmaze.com")!
        }
        
    }
    public var path: String {
        switch self {
        case .search:
            return "search/shows"
        case .schedule:
            return "schedule"
        case .detail(let identifier):
            return "shows/\(identifier)"
        case .image(let url) :
            return url.path
        }
    }
    public var method: Moya.Method {
        return .get
    }
    public var parameters: [String: Any]? {
        switch self {
        case .search(let query):
            return ["q":query]
        case .schedule(let country, let date):
            var d = [String:String]()
            if (country != nil) {
                d["country"] = country!
            }
            if (date != nil) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                d["date"] = dateFormatter.string(from: date!)
            }
            return d
        default :
            return nil
        }
    }
}
