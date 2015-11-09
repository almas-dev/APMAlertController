//
//  ViewController.swift
//  APMAlertController
//
//  Created by Alexander Maslennikov on 11/09/2015.
//  Copyright (c) 2015 Alexander Maslennikov. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let tableView = UITableView()
    private static let cellIdentifier = "Cell"
    let sectionsArray = ["System", "My Alert", "My ActionSheet"]
    let titlesArray = [
            ["System Alert", "System ActionSheet"],
            ["Alert 1", "Alert 2", "Alert 3", "Alert 4"],
            ["ActionSheet 1", "ActionSheet 2", "ActionSheet 3"]
    ]
    var actions: [[(indexPath: NSIndexPath) -> Void]] {
        return [
            [systemAlert, systemActionSheet],
            [systemAlert, systemAlert, systemAlert, systemAlert],
            [systemActionSheet, systemActionSheet, systemActionSheet]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "AlertController Example"
        view.backgroundColor = UIColor.lightGrayColor()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.0
        view.addSubview(tableView)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.dynamicType.cellIdentifier)
        tableView.snp_makeConstraints {
            (make) in
            make.edges.equalTo(view)
        }
    }

    func systemAlert(indexPath: NSIndexPath) {
        let title = titlesArray[indexPath.section][indexPath.row]

        let alertController: UIAlertController = UIAlertController(title: title, message: "This is message", preferredStyle: .Alert)
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
        self.presentViewController(alertController, animated: true, completion: nil)
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
        self.presentViewController(alertController, animated: true, completion: nil)
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