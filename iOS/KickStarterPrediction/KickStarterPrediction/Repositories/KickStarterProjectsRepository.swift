//
//  KickStarterProjectsRepository.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class KickStarterProjectsRepository {
    
    var lastResponse: KickStarterProjectsListResponse?
    var projects: [KickStarterProject] = [KickStarterProject]()
    var hasMoreProjectsToLoad = true
    let mlModel = KickStarterMLModel()

    func getNextProjects(completionHandler: @escaping (Result<[KickStarterProject]?>) -> Void) {
        guard hasMoreProjectsToLoad else {
            completionHandler(Result.success(nil))
            return
        }
        let page = (lastResponse?.page ?? 0)+1
        let url = "https://www.kickstarter.com/projects/search.json?page=\(page)"
        Alamofire.request(url).responseObject { (response: DataResponse<KickStarterProjectsListResponse>) in
            if response.result.isFailure {
                completionHandler(Result.failure(response.result.error!))
            } else {
                self.lastResponse = response.result.value
                self.lastResponse?.page = page
                if page == 1 {
                    self.projects.removeAll()
                }
                let newProjects = self.lastResponse?.projects?.filter{ self.projects.index(of: $0) == nil }
                newProjects?.forEach { self.projects.append($0) }
                self.hasMoreProjectsToLoad = self.lastResponse?.hasMore ?? false
                //Predict success for each projects in background
                DispatchQueue.global(qos: .background).async {
                    newProjects?.forEach { $0.predictSuccess(model: self.mlModel) }
                    DispatchQueue.main.async {
                        //Call Handler in main queue
                        completionHandler(Result.success(newProjects))
                    }
                }
            }
        }
    }
    
}
