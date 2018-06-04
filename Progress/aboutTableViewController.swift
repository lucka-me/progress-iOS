//
//  aboutTableViewController.swift
//  Progress
//
//  Created by Lucka on 21/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import UIKit

class aboutTableViewController: UITableViewController {

    @IBOutlet var aboutTableView: UITableView!
    @IBOutlet weak var versionCell: UITableViewCell!
    @IBOutlet weak var creditDeveloperCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the version and build
        let releaseVersionNumber: String = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!
        let buildVersionNumber: String = (Bundle.main.infoDictionary!["CFBundleVersion"] as? String)!
        
        versionCell.textLabel?.text = "\(releaseVersionNumber) (\(buildVersionNumber))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        aboutTableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            UIApplication.shared.open(URL(string: "https://twitter.com/LuckaZhao")!)
        }
    }

}
