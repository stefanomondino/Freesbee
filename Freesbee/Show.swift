//
//  Show.swift
//  Freesbee
//
//  Created by Stefano Mondino on 18/02/17.
//  Copyright © 2017 Synesthesia. All rights reserved.
//


import Foundation
import Gloss
import Moya
import Result
import Boomerang


struct QueryResult : Decodable, ModelType {
    var score:Int?
    var show:Show!
    var title: String? { return ""}
    init?(json: JSON) {
        self.score = "score" <~~ json
        self.show = "show" <~~ json
    }
}

struct Show : Decodable, ModelType {
    var id:Int?
    var title:String?
    var imageURL : URL?
    var placeholder = Image()
    var minutes:Int?
    var summary:String?
    var premiereDate:Date?
    var rating:Float?
    init?(json: JSON) {
        guard let name: String = "name" <~~ json
            else { return nil }
        self.title  =  name
        self.id = "id" <~~ json
        self.minutes = "runtime" <~~ json
        self.summary = "summary" <~~ json
        self.rating = "rating.average" <~~ json
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.premiereDate = Decoder.decode(dateForKey: "premiered", dateFormatter: dateFormatter)(json)
        let imagePath:String? = "image.original" <~~ json
        self.imageURL =  URL(string: imagePath?.replacingOccurrences(of: "http://", with: "https://") ?? "")
    }
    

    
    static var placeholder = Show.init(json: ["name":""])
    
}
