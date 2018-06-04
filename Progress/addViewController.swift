//
//  addViewController.swift
//  Progress
//
//  Created by Lucka on 20/9/17.
//  Copyright © 2017年 Lucka. All rights reserved.
//

import UIKit

// Refrence: https://stackoverflow.com/questions/26561461/outlets-cannot-be-connected-to-repeating-content-ios
class addTitleCell: UITableViewCell {
    @IBOutlet weak var titleTextField: UITextField!
}

class addViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var addTableView: UITableView!
    
    let titleTextFieldTag: Int = 1
    let startDatePickerTag: Int = 21
    let endDatePickerTag: Int = 22
    let detailTextViewTag: Int = 31
    
    let datePickerCellRowHeight: CGFloat = 216
    let descriptionCellRowHeight: CGFloat = 300
    
    var isStartDatePickerShowing: Bool = false
    var isEndDatePickerShowing: Bool = false
    
    let dateFormatController: DateFormatter = DateFormatter()
    
    var startDate: Date = Date()
    var endDate: Date = Date()
    
    let titleCellID: String = "addTitleCell"
    let dateCellID: String = "dateCell"
    let startDatePickerCellID: String = "startDatePickerCell"
    let endDatePickerCellID: String = "endDatePickerCell"
    let detailCellID: String = "addDetailCell"
    
    let titleForHeaderInSection: [String] = [
        "",
        "",
        "",
        "Description (Optional)"
    ]
    let titleForFooterInSection: [String] = [
        "Tap to enter the title.",
        "Tap to select the start date.",
        "Tap to select the end date.",
        "Tap to enter the description."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Touch anywhere to end editing
        // Refrence: https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //addTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result: Int = 1
        if section == 1 && isStartDatePickerShowing {
            result = 2
        } else if section == 2 && isEndDatePickerShowing {
            result = 2
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = addTableView.rowHeight
        if indexPath == IndexPath(row: 1, section: 1) || indexPath == IndexPath(row: 1, section: 2) {
            height = datePickerCellRowHeight
        } else if indexPath.section == 3 {
            height = descriptionCellRowHeight
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection[section]
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection[section]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newCell: UITableViewCell = UITableViewCell()
        
        dateFormatController.dateStyle = .long
        dateFormatController.timeStyle = .none
        
        if indexPath.section == 0 {
            newCell = addTableView.dequeueReusableCell(withIdentifier: titleCellID)!
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                newCell = addTableView.dequeueReusableCell(withIdentifier: dateCellID)!
                newCell.textLabel?.text = "Start Date"
                newCell.detailTextLabel?.text = dateFormatController.string(from: startDate)
            } else if indexPath.row == 1 {
                newCell = addTableView.dequeueReusableCell(withIdentifier: startDatePickerCellID)!
                let startDatePicker: UIDatePicker = newCell.viewWithTag(startDatePickerTag) as! UIDatePicker
                startDatePicker.addTarget(self, action: #selector(startDatePickerChanged(datePicker:)), for: .valueChanged)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                newCell = addTableView.dequeueReusableCell(withIdentifier: dateCellID)!
                newCell.textLabel?.text = "End Date"
                newCell.detailTextLabel?.text = dateFormatController.string(from: endDate)
            } else if indexPath.row == 1 {
                newCell = addTableView.dequeueReusableCell(withIdentifier: endDatePickerCellID)!
                let endDatePicker: UIDatePicker = newCell.viewWithTag(endDatePickerTag) as! UIDatePicker
                endDatePicker.addTarget(self, action: #selector(endDatePickerChanged(datePicker:)), for: .valueChanged)
            }
        } else if indexPath.section == 3 {
            newCell = addTableView.dequeueReusableCell(withIdentifier: detailCellID)!
        }
        
        return newCell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            addTableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 1 {
            addTableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 && isStartDatePickerShowing {
                isStartDatePickerShowing = false
                addTableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .top)
            } else if indexPath.row == 0 && !isStartDatePickerShowing {
                if isEndDatePickerShowing {
                    isEndDatePickerShowing = false
                    addTableView.deleteRows(at: [IndexPath(row: 1, section: 2)], with: .top)
                }
                isStartDatePickerShowing = true
                addTableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .top)
            }
        } else if indexPath.section == 2 {
            addTableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 0 && isEndDatePickerShowing {
                isEndDatePickerShowing = false
                addTableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .top)
            } else if indexPath.row == 0 && !isEndDatePickerShowing {
                if isStartDatePickerShowing {
                    isStartDatePickerShowing = false
                    addTableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .top)
                }
                isEndDatePickerShowing = true
                addTableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .top)
            }
        } else if indexPath.section == 3 {
            addTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // DatePicker Selecting
    @objc func startDatePickerChanged(datePicker: UIDatePicker) {
        startDate = datePicker.date
        let startDateCell = addTableView.cellForRow(at: IndexPath(row: 0, section: 1))
        startDateCell?.detailTextLabel?.text = dateFormatController.string(from: startDate)
    }

    @objc func endDatePickerChanged(datePicker: UIDatePicker) {
        endDate = datePicker.date
        let endDateCell = addTableView.cellForRow(at: IndexPath(row: 0, section: 2))
        endDateCell?.detailTextLabel?.text = dateFormatController.string(from: endDate)
    }
    
    // Button Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let titleCell = addTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let titleTextField: UITextField = titleCell?.viewWithTag(titleTextFieldTag) as! UITextField
        let newTitle: String = titleTextField.text!
        
        if newTitle == "" {
            // Check if the title is empty
            let titleEmptyAlert: UIAlertController = UIAlertController(title: "Title Empty", message: "The title cannot be empty.", preferredStyle: .alert)
            titleEmptyAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(titleEmptyAlert, animated: true, completion: nil)
        } else if startDate > endDate {
            // Check if the dates are avaliable
            let dateUnavaliableAlert: UIAlertController = UIAlertController(title: "Date Unavaliable", message: "The dates are unavaliable, please check if the start date is later than the end date.", preferredStyle: .alert)
            dateUnavaliableAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dateUnavaliableAlert, animated: true, completion: nil)
        } else {
            // Delete the Date Pickers first, or app will crash
            if isStartDatePickerShowing {
                isStartDatePickerShowing = false
                addTableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .top)
            }
            if isEndDatePickerShowing {
                isEndDatePickerShowing = false
                addTableView.deleteRows(at: [IndexPath(row: 1, section: 2)], with: .top)
            }
            
            let detailCell = addTableView.cellForRow(at: IndexPath(row: 0, section: 3))
            let detailTextView: UITextView = detailCell?.viewWithTag(detailTextViewTag) as! UITextView
            let newDetail: String = detailTextView.text
            
            // Set the time of start date and end date
            // Refrence: http://www.jianshu.com/p/a6275cc54e04
            let calender: Calendar = Calendar.current
            // startDate -> 00:00:00
            var dateComponents = calender.dateComponents([.year,.month, .day, .hour,.minute,.second], from: startDate)
            dateComponents.hour = 0
            dateComponents.minute = 0
            dateComponents.second = 0
            startDate = calender.date(from: dateComponents)!
            // endDate -> 23:59:59
            dateComponents = calender.dateComponents([.year,.month, .day, .hour,.minute,.second], from: endDate)
            dateComponents.hour = 23
            dateComponents.minute = 59
            dateComponents.second = 59
            endDate = calender.date(from: dateComponents)!
            
            let newEvent: event = event(title: newTitle, detail: newDetail, startDate: startDate, endDate: endDate)
            
            mainEventListController.addEvent(newEvent: newEvent)
            
            startDate = Date()
            endDate = Date()
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
