//
//  KickStarterProjectsListViewController.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import UIKit

class KickStarterProjectsListViewController: UITableViewController {
    
    let kickStartProjectsRepository = KickStarterProjectsRepository()
    var isLoadingProjects = false
    
    override func viewDidLoad() {
        tableView.register(R.nib.kickStarterProjectTableViewCell(), forCellReuseIdentifier: "KickStarterProjectTableViewCell")
        loadProjects()
        super.viewDidLoad()
    }
    
    private func loadProjects() {
        self.isLoadingProjects = true
        kickStartProjectsRepository.getNextProjects() { result in
            self.isLoadingProjects = false
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kickStartProjectsRepository.projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KickStarterProjectTableViewCell", for: indexPath) as! KickStarterProjectTableViewCell
        let project = kickStartProjectsRepository.projects[indexPath.row]
        cell.configureWithProject(project: project)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoadingProjects && indexPath.row >= kickStartProjectsRepository.projects.count - 5 {
            loadProjects()
        }
    }
}
