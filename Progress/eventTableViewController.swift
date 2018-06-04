//
//  eventTableViewController.swift
//  Progress
//
//  Created by Lucka on 23/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import UIKit

class eventTableViewController: UITableViewController {
    
    @IBOutlet var eventTableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var detailStringCell: UITableViewCell!
    @IBOutlet weak var startDateCell: UITableViewCell!
    @IBOutlet weak var endDateCell: UITableViewCell!
    @IBOutlet weak var detailTextView: UITextView!
    
    var numberOfRowsIn: [Int] = [2, 2, 1]
    var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatController: DateFormatter = DateFormatter()
        dateFormatController.dateStyle = .long
        dateFormatController.timeStyle = .none
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        let eventCoreData = mainEventListController.eventList[selectedRow!]
        let newTitle = eventCoreData.value(forKey: "title") as? String
        let newDetail = eventCoreData.value(forKey: "detail") as? String
        let newStartDate = eventCoreData.value(forKey: "startDate") as? Date
        let newEndDate = eventCoreData.value(forKey: "endDate") as? Date
        let newEvent = event(title: newTitle!, detail: newDetail!, startDate: newStartDate!, endDate: newEndDate!)
        
        self.title = newEvent.title
        progressView.progress = Float(newEvent.progress)
        detailStringCell.textLabel?.text = newEvent.cellDetailString
        startDateCell.detailTextLabel?.text = dateFormatController.string(from: newEvent.startDate)
        endDateCell.detailTextLabel?.text = dateFormatController.string(from: newEvent.endDate)
        detailTextView.text = newEvent.detail
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsIn[section]
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventTableView.deselectRow(at: indexPath, animated: true)
    }

}
