//
//  Created by Alexander Maslennikov on 11/09/2015.
//  Copyright (c) 2015 Alexander Maslennikov. All rights reserved.
//

import APMAlertController
import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let sectionsArray = ["System", "Custom Alert", "Custom ActionSheet"]
    let titlesArray = [
        ["System Alert", "System ActionSheet"],
        [
            "Alert Text Title",
            "Alert Text Title Message Long",
            "Alert Image Title With Tint",
            "Alert Text Title Separator With Tint",
            "Alert Text Title Attributed Message",
            "Alert Text Title View Message",
            "Alert Text Field View Message",
            "Alert Image Title Colored Button"
        ],
        ["In progress"]
    ]
    var actions: [[(_ indexPath: IndexPath) -> Void]] {
        return [
            [systemAlert, systemActionSheet],
            [
                alertTextTitle,
                alertTextTitleMessageLong,
                alertImageTitleWithTint,
                alertTextTitleSeparatorWithTint,
                alertTextTitleAttributedMessage,
                alertTextTitleViewMessage,
                alertTextFieldView,
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        view.addConstraints([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        ])
    }

    // MARK: - System Alert

    func systemAlert(_ indexPath: IndexPath) {
        let title = NSLocalizedString("title-long", comment: "Long title")
        let message = NSLocalizedString("message-long", comment: "Long message")

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            //Do some stuff
        }
        alertController.addAction(cancelAction)
        let defaultAction = UIAlertAction(title: "Default", style: .default) { _ in
            //Do some stuff
        }
        alertController.addAction(defaultAction)
        let desctructAction = UIAlertAction(title: "Destruct", style: .destructive) { _ in
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            //Just dismiss the action sheet
        }
        alertController.addAction(cancelAction)
        let takePictureAction = UIAlertAction(title: "Take Picture", style: .default) { _ in
            //Code for launching the camera goes here
        }
        alertController.addAction(takePictureAction)
        let choosePictureAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { _ in
            //Code for picking from camera roll goes here
        }
        alertController.addAction(choosePictureAction)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Custom Alert

    func alertTextTitle(_ indexPath: IndexPath) {
        let title = titlesArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        let message = "This is message. One, Two. Message."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func alertTextTitleMessageLong(_ indexPath: IndexPath) {
        let title = NSLocalizedString("title-long", comment: "Long title")
        let message = NSLocalizedString("message-long", comment: "Long message")

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = APMAlertAction(title: "Cancel", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .cancel) { _ in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        let desctructAction = APMAlertAction(title: "Destruct", style: .destructive) { _ in
            print("The simple alert destruct action.")
        }
        alertController.addAction(desctructAction)
        present(alertController, animated: true, completion: nil)
    }

    func alertImageTitleWithTint(_ indexPath: IndexPath) {
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .alert)
        alertController.tintColor = UIColor.brown
        let cancelAction = APMAlertAction(title: "Cancel", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .cancel) { _ in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        present(alertController, animated: true, completion: nil)
    }

    func alertTextTitleSeparatorWithTint(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"
        let message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        let alertController = APMAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purple
        let cancelAction = APMAlertAction(title: "Ok", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func alertTextTitleAttributedMessage(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"
        let attributedMessage = NSMutableAttributedString(
            string: "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit,\nsed do eiusmod tempor\nincididunt ut labore et dolore magna aliqua."
        )
        attributedMessage.addAttributes([
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor: UIColor(red: 0.581, green: 0.129, blue: 0.575, alpha: 1.0)
        ],
            range: NSRange(location: 0, length: 28)
        )
        attributedMessage.addAttributes([
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor(red: 0.276, green: 0.32, blue: 0.6, alpha: 1.0)
        ],
            range: NSRange(location: 28, length: 29)
        )
        attributedMessage.addAttributes([
            NSAttributedStringKey.font: UIFont.italicSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor: UIColor(red: 0.488, green: 0.593, blue: 0.424, alpha: 1.0)
        ],
            range: NSRange(location: 57, length: 22)
        )
        attributedMessage.addAttributes([
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
            NSAttributedStringKey.foregroundColor: UIColor(red: 0.0, green: 0.656, blue: 0.571, alpha: 1.0)
        ],
            range: NSRange(location: 79, length: 44)
        )

        let alertController = APMAlertController(title: title, attributedMessage: attributedMessage, preferredStyle: .alert)
        alertController.showTitleMessageSeparator = true
        alertController.tintColor = UIColor.purple
        let defaultAction = APMAlertAction(title: "Default", style: .default) { _ in
            print("The simple alert default action.")
        }
        alertController.addAction(defaultAction)
        let cancelAction = APMAlertAction(title: "Ok", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func alertTextFieldView(_ indexPath: IndexPath) {
        let alertController = APMAlertController(title: title, preferredStyle: .alert)
        alertController.showTitleMessageSeparator = true
        let cancelAction = APMAlertAction(title: "Ok", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)

        let contentView = alertController.messageContentView
        contentView.layoutMargins = UIEdgeInsets(top: -15, left: 15, bottom: 0, right: 15)

        let textField = UITextField()
        textField.placeholder = "Text field"
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        contentView.addArrangedSubview(textField)
        present(alertController, animated: true, completion: nil)
    }

    func alertTextTitleViewMessage(_ indexPath: IndexPath) {
        let title = "ABC123-45678-90"

        let alertController = APMAlertController(title: title, preferredStyle: .alert)
        alertController.showTitleMessageSeparator = true
        let cancelAction = APMAlertAction(title: "Ok", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)

        let contentView = alertController.messageContentView
        contentView.layoutMargins = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        contentView.addArrangedSubview(view)

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

        present(alertController, animated: true, completion: nil)
    }

    func alertImageTitleColoredButton(_ indexPath: IndexPath) {
        let message = "This is message. One, Two. Message. Long message. Test."

        let alertController = APMAlertController(titleImage: UIImage(named: "alert-controller-error"), message: message, preferredStyle: .alert)
        alertController.separatorColor = UIColor.white
        alertController.buttonTitleColor = UIColor.white
        alertController.customButtonFont = UIFont.systemFont(ofSize: 30)
        alertController.customDescriptionFont = UIFont.systemFont(ofSize: 25)
        alertController.buttonBackgroundColor = UIColor(red: 48 / 255, green: 176 / 255, blue: 214 / 255, alpha: 1)
        alertController.disableImageIconTemplate = true
        alertController.tintColor = UIColor.magenta
        let cancelAction = APMAlertAction(title: "Cancel", style: .cancel) { _ in
            print("The simple alert cancel action.")
        }
        alertController.addAction(cancelAction)
        let testAction = APMAlertAction(title: "Test", style: .cancel) { _ in
            print("The simple alert test action.")
        }
        alertController.addAction(testAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showAlert = actions[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        showAlert(indexPath)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = titlesArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
