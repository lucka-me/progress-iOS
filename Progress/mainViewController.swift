//
//  mainViewController.swift
//  Progress
//
//  Created by Lucka on 20/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import UIKit
import CoreData

// Create customized prototype cells
// Refrence: https://stackoverflow.com/questions/33004189/swift-custom-cell-creating-your-own-cell-with-labels
class mainEventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var detailLabel: UILabel!
}

class mainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mainTableView: UITableView!
    
    let mainEventCellID: String = "mainEventCell"
    let mainEventCellRowHeight: CGFloat = 76.0
    let toEventSceneTag: String = "toEventScene"
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        // Remove the surplus cells below
        mainTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EventCoreData")
        
        do {
            mainEventListController.eventList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        mainTableView.reloadData()
    }
    
    // UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainEventListController.eventList.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainEventCellRowHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newCell: mainEventCell = mainTableView.dequeueReusableCell(withIdentifier: mainEventCellID) as! mainEventCell
        let eventCoreData = mainEventListController.eventList[indexPath.row]
        let newTitle = eventCoreData.value(forKey: "title") as? String
        let newDetail = eventCoreData.value(forKey: "detail") as? String
        let newStartDate = eventCoreData.value(forKey: "startDate") as? Date
        let newEndDate = eventCoreData.value(forKey: "endDate") as? Date
        let newEvent = event(title: newTitle!, detail: newDetail!, startDate: newStartDate!, endDate: newEndDate!)
        newCell.titleLabel.text = newEvent.title
        newCell.progressView.progress = Float(newEvent.progress)
        newCell.detailLabel.text = newEvent.cellDetailString
        
        return newCell
        
    }
    
    // UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        // Send value via Segue
        // Refrence: http://www.jianshu.com/p/3e1173652996
        self.performSegue(withIdentifier: toEventSceneTag, sender: nil)
        mainTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toEventSceneTag {
            let eventView: eventTableViewController = segue.destination as! eventTableViewController
            eventView.selectedRow = self.selectedRow
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            mainEventListController.removeEvent(at: indexPath.row)
            mainTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
