//
//  Created by Alexander Maslennikov on 11/09/2015.
//  Copyright (c) 2015 Alexander Maslennikov. All rights reserved.
//

import UIKit
import APMAlertController

class ViewController: UIViewController {
    let tableView = UITableView()
    let sectionsArray = ["System", "Custom Alert", "Custom ActionSheet"]
    let titlesArray = [
            ["System Alert", "System ActionSheet"],
            [
                    "Alert Text Title",
                    "Alert Text Title Long",
                    "Alert Image Title With Tint",
                    "Alert Text Title Separator With Tint",
                    "Alert Text Title Attributed Message",
                    "Alert Text Title View Message",
                    "Alert Image Title Colored Button"
            ],
            ["In progress"]
    ]
    var actions: Array<Array<(indexPath:IndexPath) -> Void>> {
        return [
                [systemAlert, systemActionSheet],
                [
                        alertTextTitle,
                        alertTextTitleColoredButtons,
                        alertImageTitleWithTint,
                        alertTextTitleSeparatorWithTint,
                        alertTextTitleAttributedMessage,
                        alertTextTitleViewMessage,
                        alertImageTitleColoredButton
                ],
                [systemActionSheet]
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "AlertController Example"
        view.backgroundColor = UIColor.lightGray

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(UITableViewCell))
        view.addConstraints([
                NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        ])

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.performTransitionToObjectiveCViewController))
    }

    func performTransitionToObjectiveCViewController() {
        let viewController = ObjectiveCViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - System Alert

    func systemAlert(_ indexPath: IndexPath) {
        let title = "Title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title." /*titlesArray[indexPath.section][indexPath.row]*/
        let message = "Message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message." /*"This is message. One, Two. Message."*/

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
            //Do some stuff
        }
        alertController.addAction(cancelAction)
        let defaultAction = UIAlertAction(title: "Default", style: .default) {
            action in
            //Do some stuff
        }
        alertController.addAction(defaultAction)
        let desctructAction = UIAlertAction(title: "Destruct", style: .destructive) {
            action in
            //Do some stuff
        }
        alertController.addAction(desctructAction)
        /*alertController.addTextFieldWithConfigurationHandler {
            textField in
            textField.textColor = UIColor.whiteColor()
            textField.backgroundColor = UIColor.magentaColor()
        }*/
        present(alertController, animated: true, completion: nil)
    }

    func systemActionSheet(_ indexPath: IndexPath) {
        let title = titlesArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]

        let alertController = UIAlertController(title: title, message: "This is message", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
            //Just dismiss the action sheet
        }
        alertController.addAction(cancelAction)
        let takePictureAction = UIAlertAction(title: "Take Picture", style: .default) {
            action in
            //Code for launching the camera goes here
        }
        alertController.addAction(takePictureAction)
        let choosePictureAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) {
            action in
            //Code for picking from camera roll goes here
        }
        alertController.addAction(choosePictureAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Custom Alert

    func alertTextTitle(_ indexPath: IndexPath) {
        let title = titlesArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let message = "This is message. One, Two. Message."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertTextTitleColoredButtons(_ indexPath: IndexPath) {
        let title = "Title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title title." /*titlesArray[indexPath.section][indexPath.row]*/
        let message = "Message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message message." /*"This is message. One, Two. Message."*/

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .Cancel) {
            action in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        let desctructAction = APMAlertAction(title: "Destruct", style: .Destructive) {
            action in
            print("The simple alert destruct action.")
        }
        alertController.addAction(desctructAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertImageTitleWithTint(_ indexPath: IndexPath) {
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .Alert)
        alertController.tintColor = UIColor.brownColor()
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .Cancel) {
            action in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertTextTitleSeparatorWithTint(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purpleColor()
        let cancelAction = APMAlertAction(title: "Ok", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertTextTitleAttributedMessage(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"
        let attributedMessage = NSMutableAttributedString(string: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,\nsed do eiusmod tempor\nincididunt ut labore et dolore magna aliqua.")
        attributedMessage.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue", size:16.0)!, range:NSMakeRange(0,28))
        attributedMessage.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue-Bold", size:14.0)!, range:NSMakeRange(28,29))
        attributedMessage.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue-MediumItalic", size:16.0)!, range:NSMakeRange(57,22))
        attributedMessage.addAttribute(NSFontAttributeName, value:UIFont(name:"HelveticaNeue-Medium", size:10.0)!, range:NSMakeRange(79,44))
        attributedMessage.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.581, green:0.129, blue:0.575, alpha:1.0), range:NSMakeRange(0,28))
        attributedMessage.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.276, green:0.32, blue:0.6, alpha:1.0), range:NSMakeRange(28,29))
        attributedMessage.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.488, green:0.593, blue:0.424, alpha:1.0), range:NSMakeRange(57,22))
        attributedMessage.addAttribute(NSForegroundColorAttributeName, value:UIColor(red:0.0, green:0.656, blue:0.571, alpha:1.0), range:NSMakeRange(79,44))

        let alertController = APMAlertController(title: title, attributedMessage: attributedMessage, preferredStyle: .Alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purpleColor()
        let defaultAction = APMAlertAction(title: "Default", style: .Default) {
            action in
            print("The simple alert default action.")
        }
        alertController.addAction(defaultAction)
        let cancelAction = APMAlertAction(title: "Ok", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertTextTitleViewMessage(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"

        let alertController = APMAlertController(title: title, preferredStyle: .Alert)
        alertController.showTitleMessageSeparator = true
        let cancelAction = APMAlertAction(title: "Ok", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)

        let contentView = alertController.messageContentView

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        contentView.addSubview(view)
        contentView.addConstraints([
                NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
        ])

        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
        view.addSubview(view1)
        view.addConstraints([
                NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 10),
                NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 5),
                NSLayoutConstraint(item: view1, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -5),
                NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -10)
        ])

        let view2 = UIView()
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.backgroundColor = alertController.separatorColor
        view.addSubview(view2)
        view.addConstraints([
                NSLayoutConstraint(item: view2, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view2, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view2, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: view2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2)
        ])

        presentViewController(alertController, animated: true, completion: nil)
    }

    func alertImageTitleColoredButton(_ indexPath: IndexPath) {
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .Alert)
        alertController.separatorColor = UIColor.whiteColor()
        alertController.buttonTitleColor = UIColor.whiteColor()
        alertController.customButtonFont = UIFont.systemFontOfSize(30)
        alertController.customDescriptionFont = UIFont.systemFontOfSize(25)
        alertController.buttonBackgroundColor = UIColor(red: 48 / 255, green: 176 / 255, blue: 214 / 255, alpha: 1)
        alertController.disableImageIconTemplate = true
        alertController.tintColor = UIColor.magentaColor()
        let cancelAction = APMAlertAction(title: "Cancel", style: .Cancel) {
            action in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .Cancel) {
            action in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showAlert = actions[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        showAlert(indexPath: indexPath)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return actions.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(UITableViewCell), for: indexPath)
        cell.textLabel?.text = titlesArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        return cell
    }
}
