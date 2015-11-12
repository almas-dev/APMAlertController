//
//  ViewController.swift
//  APMAlertController
//
//  Created by Alexander Maslennikov on 11/09/2015.
//  Copyright (c) 2015 Alexander Maslennikov. All rights reserved.
//

import UIKit
import APMAlertController

class ViewController: UIViewController {
    let tableView = UITableView()
    private static let cellIdentifier = "Cell"
    let sectionsArray = ["System", "My Alert", "My ActionSheet"]
    let titlesArray = [
            ["System Alert", "System ActionSheet"],
            ["My Alert Text Title", "My Alert Icon Title", "Alert 3", "Alert 4"],
            ["ActionSheet 1", "ActionSheet 2", "ActionSheet 3"]
    ]
    var actions: [[(indexPath: NSIndexPath) -> Void]] {
        return [
            [systemAlert, systemActionSheet],
            [myAlertTextTitle, myAlertImageTitle, systemAlert, systemAlert],
            [systemActionSheet, systemActionSheet, systemActionSheet]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "AlertController Example"
        view.backgroundColor = UIColor.lightGrayColor()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.0
        view.addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.dynamicType.cellIdentifier)
        view.addConstraints([
                NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        ])
    }

    //System
    func systemAlert(indexPath: NSIndexPath) {
        var title = titlesArray[indexPath.section][indexPath.row]
        var message = "This is message. One, Two. Message."

        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            //Do some stuff
        }
        alertController.addAction(cancelAction)
        let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) {
            action in
            //Do some stuff
        }
        alertController.addAction(nextAction)
        alertController.addTextFieldWithConfigurationHandler {
            textField in
            textField.textColor = UIColor.whiteColor()
            textField.backgroundColor = UIColor.magentaColor()
        }
        presentViewController(alertController, animated: true, completion: nil)
    }

    func systemActionSheet(indexPath: NSIndexPath) {
        let title = titlesArray[indexPath.section][indexPath.row]

        let alertController: UIAlertController = UIAlertController(title: title, message: "This is message", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            //Just dismiss the action sheet
        }
        alertController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) {
            action in
            //Code for launching the camera goes here
        }
        alertController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) {
            action in
            //Code for picking from camera roll goes here
        }
        alertController.addAction(choosePictureAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func myAlertTextTitle(indexPath: NSIndexPath) {
        let title = titlesArray[indexPath.section][indexPath.row]
        let message = "This is message. One, Two. Message."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            NSLog("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func myAlertImageTitle(indexPath: NSIndexPath) {
        let title = titlesArray[indexPath.section][indexPath.row]
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .Alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            NSLog("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .Cancel) {
            action in
            NSLog("The simple alert test action.")
        }
        alertController.addAction(testAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let showAlert = actions[indexPath.section][indexPath.row]
        showAlert(indexPath: indexPath)

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return actions.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.dynamicType.cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
        return cell
    }
}