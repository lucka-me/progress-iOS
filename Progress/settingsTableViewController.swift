//
//  settingsTableViewController.swift
//  Progress
//
//  Created by Lucka on 26/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import UIKit

class settingsTableViewController: UITableViewController {

    @IBOutlet var settingsTableView: UITableView!
    
    let numberOfRowsIn: [Int] = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfRowsIn.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsIn[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTableView.deselectRow(at: indexPath, animated: true)
    }

}
