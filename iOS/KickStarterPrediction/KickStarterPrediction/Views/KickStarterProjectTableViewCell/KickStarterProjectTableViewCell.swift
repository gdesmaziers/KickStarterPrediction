//
//  KickStarterProjectTableViewCell.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import UIKit
import AlamofireImage

class KickStarterProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pledgeLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var backersCountLabel: UILabel!
    @IBOutlet weak var projectImage: UIImageView?
    
    func configureWithProject(project: KickStarterProject) {
        imageView?.image = nil
        if let url = URL(string: project.imageUrl) {
            projectImage?.af_setImage(withURL: url)
        }
        nameLabel.text = project.name
        let pledge = NumberFormatter.dollarFormatter.string(for: project.pledge)
        let goal = NumberFormatter.dollarFormatter.string(for: project.goal)
        pledgeLabel.text = "\(pledge!) / \(goal!)"
        launchDateLabel.text = DateFormatter.displayDateFormatter.string(for: project.launchDate)
        let deadlineDate = DateFormatter.displayDateFormatter.string(for: project.deadlineDate)
        deadlineDateLabel.text = "\(deadlineDate!) (\(project.daysLeft) days left)"
        backersCountLabel.text = "\(project.backersCount!)"
        if let predictedSuccess = project.predictedSuccess {
            contentView.backgroundColor = (predictedSuccess || project.alreadySuccessfull) ? UIColor.success : UIColor.failure
        } else {
            contentView.backgroundColor = project.alreadySuccessfull ? UIColor.success : UIColor.white
        }
    }
}
