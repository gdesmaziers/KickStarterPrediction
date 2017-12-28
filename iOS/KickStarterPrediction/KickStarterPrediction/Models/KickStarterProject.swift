//
//  KickStarterProject.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class KickStarterProject: Mappable, Equatable {
    
    var identifier: Int!
    var imageUrl: String!
    var name: String!
    var launchDate: Date!
    var goal: Double!
    var pledge: Double!
    var deadlineDate: Date!
    var daysLeft: Int {
        return Int(deadlineDate.timeIntervalSinceNow / (24*3600))
    }
    var backersCount: Int!
    var duration: Double {
        return deadlineDate.timeIntervalSince(launchDate)
    }
    var alreadySuccessfull: Bool {
        return pledge >= goal
    }
    var predictedSuccess: Bool?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        imageUrl <- map["photo.full"]
        launchDate <- (map["launched_at"], DateTransform())
        deadlineDate <- (map["deadline"], DateTransform())
        goal <- map["goal"]
        pledge <- map["pledged"]
        backersCount <- map["backers_count"]
    }

    func predictSuccess(model: KickStarterMLModel) {
        //Predict success using the CoreML model
        let prediction = try? model.prediction(goal: goal, backersCount: Double(backersCount), duration: duration)
        //Save result in predictedSuccess attribute
        if let success = prediction?.prediction {
            predictedSuccess = success == 1
        }
    }
    
    static func == (lhs: KickStarterProject, rhs: KickStarterProject) -> Bool {
        return lhs.identifier! == rhs.identifier!
    }

}
