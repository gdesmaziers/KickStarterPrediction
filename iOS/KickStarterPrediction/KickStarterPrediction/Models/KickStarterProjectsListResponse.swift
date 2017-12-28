//
//  KickStarterProjectsListResponse.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class KickStarterProjectsListResponse: Mappable {
    
    var projects: [KickStarterProject]?
    var page: Int?
    var hasMore: Bool?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        projects <- map["projects"]
        hasMore <- map["has_more"]
    }

}
 
