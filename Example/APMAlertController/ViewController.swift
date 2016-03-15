//
//  Created by Alexander Maslennikov on 11/09/2015.
//  Copyright (c) 2015 Alexander Maslennikov. All rights reserved.
//

import UIKit
import APMAlertController

class ViewController: UIViewController {
    let tableView = UITableView()
    private static let cellIdentifier = "Cell"
    let sectionsArray = ["System", "Custom Alert", "Custom ActionSheet"]
    let titlesArray = [
            ["System Alert", "System ActionSheet"],
            ["Alert Text Title", "Alert Text Title Colored Buttons", "Alert Icon Title With Tint", "Alert Text Title Separator With Tint", "Attributed Alert"],
            ["In progress"]
    ]
    var actions: Array<Array<(indexPath:NSIndexPath) -> Void>> {
        return [
                [systemAlert, systemActionSheet],
                [alertTextTitle, alertTextTitleColoredButtons, alertImageTitleWithTint, alertTextTitleSeparatorWithTint, attributedAlert],
                [systemActionSheet]
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
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.dynamicType.cellIdentifier)
        view.addConstraints([
                NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        ])
    }

    // System Alert
    func systemAlert(indexPath: NSIndexPath) {
        let title = "Title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title." /*titlesArray[indexPath.section][indexPath.row]*/
        let message = "Message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message." /*"This is message. One, Two. Message."*/

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            //Do some stuff
        }
        alertController.addAction(cancelAction)
        let defaultAction = UIAlertAction(title: "Default", style: .Default) {
            action in
            //Do some stuff
        }
        alertController.addAction(defaultAction)
        let desctructAction = UIAlertAction(title: "Destruct", style: .Destructive) {
            action in
            //Do some stuff
        }
        alertController.addAction(desctructAction)
        /*alertController.addTextFieldWithConfigurationHandler {
            textField in
            textField.textColor = UIColor.whiteColor()
            textField.backgroundColor = UIColor.magentaColor()
        }*/
        presentViewController(alertController, animated: true, completion: nil)
    }

    func systemActionSheet(indexPath: NSIndexPath) {
        let title = titlesArray[indexPath.section][indexPath.row]

        let alertController = UIAlertController(title: title, message: "This is message", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            action in
            //Just dismiss the action sheet
        }
        alertController.addAction(cancelAction)
        let takePictureAction = UIAlertAction(title: "Take Picture", style: .Default) {
            action in
            //Code for launching the camera goes here
        }
        alertController.addAction(takePictureAction)
        let choosePictureAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) {
            action in
            //Code for picking from camera roll goes here
        }
        alertController.addAction(choosePictureAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    // Custom Alert
    func alertTextTitle(indexPath: NSIndexPath) {
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

    func alertTextTitleColoredButtons(indexPath: NSIndexPath) {
        let title = "Title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title." /*titlesArray[indexPath.section][indexPath.row]*/
        let message = "Message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message." /*"This is message. One, Two. Message."*/

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
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
        let desctructAction = APMAlertAction(title: "Destruct", style: .Destructive) {
            action in
            NSLog("The simple alert destruct action.")
        }
        alertController.addAction(desctructAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertImageTitleWithTint(indexPath: NSIndexPath) {
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .Alert)
        alertController.tintColor = UIColor.brownColor()
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

    func alertTextTitleSeparatorWithTint(indexPath: NSIndexPath) {
        let title = "ABC123-45678-90"
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purpleColor()
        let cancelAction = APMAlertAction(title: "Ok", style: .Cancel) {
            action in
            NSLog("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func attributedAlert(indexPath: NSIndexPath) {
        let title = "ABC123-45678-90"
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purpleColor()
        let defaultAction = APMAlertAction(title: "Default", style: .Default) {
            action in
            NSLog("The simple alert default action.")
        }
        alertController.addAction(defaultAction)
        let cancelAction = APMAlertAction(title: "Ok", style: .Cancel) {
            action in
            NSLog("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
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