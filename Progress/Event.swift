//
//  Event.swift
//  Progress
//
//  Created by Lucka on 20/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let secondOfOneDay: Int = 3600 * 24

class event {
    var title: String
    var detail: String
    var cellDetailString: String
    var startDate: Date
    var endDate: Date
    var length: TimeInterval
    var past: TimeInterval
    var remain: TimeInterval
    var isFinished: Bool
    var progress: Double
    
    init(title: String,
         detail: String = "",
         startDate: Date = Date(),
         endDate: Date) {
        self.title = title
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
        length = endDate.timeIntervalSince(startDate)
        if endDate <= Date() {
            isFinished = true
            past = length
            remain = 0.0
            progress = 1.0
            cellDetailString = "Finished."
        } else if startDate >= Date() {
            isFinished = false
            past = 0.0
            remain = 1.0
            progress = 0.0
            cellDetailString = "Not start yet."
        } else {
            past = 0 - startDate.timeIntervalSinceNow
            remain = endDate.timeIntervalSinceNow
            progress = past / length
            isFinished = false
            cellDetailString = String(format: "%.1f%% - %d days past, %d days remain.", progress * 100, Int(past / Double(secondOfOneDay) + 0.5), Int(remain / Double(secondOfOneDay) + 0.5))
        }
    }
    
    /* Update Functions */
    func updateAllTime() -> Int {
        length = endDate.timeIntervalSince(startDate)
        if endDate <= Date() {
            isFinished = true
            past = length
            remain = 0.0
            progress = 1.0
            cellDetailString = "Finished."
        } else if startDate >= Date() {
            past = 0.0
            remain = 1.0
            progress = 0.0
            cellDetailString = "Not start yet."
        } else {
            past = 0 - startDate.timeIntervalSinceNow
            remain = endDate.timeIntervalSinceNow
            progress = past / length
            isFinished = false
            cellDetailString = String(format: "%.1f %% - %d days past, %d days remain.", progress * 100, Int(past / Double(secondOfOneDay) + 0.5), Int(remain / Double(secondOfOneDay) + 0.5))
        }
        return 0
    }
    
    // Error 11: the title is empty
    func updateTitle(newTitle: String) -> Int {
        if newTitle.isEmpty {
            return 11
        } else {
            title = newTitle
        }
        return 0
    }
    
    func updateDetail(newDetail: String) -> Int {
        detail = newDetail
        return 0
    }
    
    // Error 21: startDate is later than the endDate
    func updateDates(newStartDate: Date, newEndDate: Date) -> Int {
        if newStartDate >= newEndDate {
            return 21
        } else {
            startDate = newStartDate
            endDate = newEndDate
            updateAllTime()
        }
        return 0
    }
    
}

class eventListController {
    var eventList: [NSManagedObject] = []
    
    func addEvent(newEvent: event) {
        
        // Core Date Refrence: https://www.raywenderlich.com/145809/getting-started-core-data-tutorial
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "EventCoreData", in: managedContext)!
        let eventCoreData = NSManagedObject(entity: entity, insertInto: managedContext)
        
        eventCoreData.setValue(newEvent.title, forKeyPath: "title")
        eventCoreData.setValue(newEvent.detail, forKeyPath: "detail")
        eventCoreData.setValue(newEvent.startDate, forKeyPath: "startDate")
        eventCoreData.setValue(newEvent.endDate, forKeyPath: "endDate")
        
        do {
            try managedContext.save()
            eventList.append(eventCoreData)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        //eventList.append(newEvent)
    }
    
    func removeEvent(at: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        managedContext.delete(eventList[at])
        do {
            try managedContext.save()
            eventList.remove(at: at)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

var mainEventListController: eventListController = eventListController()

// Data for test
func buildTestEventList() {
    let dateFormatController: DateFormatter = DateFormatter()
    dateFormatController.dateFormat = "yyyy-MM-dd HH:mm"
    
    mainEventListController.addEvent(newEvent: event(title: "This year", detail: "", startDate: dateFormatController.date(from: "2017-01-01 00:00")!, endDate: dateFormatController.date(from: "2017-12-31 23:59")!))
    mainEventListController.addEvent(newEvent: event(title: "Nothing", endDate: dateFormatController.date(from: "2017-12-31 23:59")!))
    print("Test Event List Built.")
}
