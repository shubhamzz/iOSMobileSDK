//
//  TableViewController.swift
//  QualarooMobileSDKDemo
//
//  Created by Ruben Nine on 25/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

import UIKit
import QualarooMobileSDK

class TableViewController: UITableViewController, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var surveyIDTextField: UITextField!
    @IBOutlet weak var attachmentPositionPickerView: UIPickerView!
    @IBOutlet weak var showSurveyButton: UIButton!
    @IBOutlet weak var buildLabel: UILabel!

    var surveyID: UInt {
        get {
            return UInt(NSUserDefaults.standardUserDefaults().integerForKey("DemoSurveyID"))
        }

        set {
            NSUserDefaults.standardUserDefaults().setInteger(Int(newValue), forKey: "DemoSurveyID")

            if qualaroo != nil && newValue != 0 {
                showSurveyButton.enabled = true
            } else {
                showSurveyButton.enabled = false
            }
        }
    }

    var apiKey: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey("DemoAPIKey")
        }

        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "DemoAPIKey")

            showSurveyButton.enabled = false

            if let newValue = newValue {
                instantiateQualarooMobileWithAPIKey(newValue)
            }
        }
    }

    var attachmentPosition: QualarooSurveyPosition {
        get {
            var position: QualarooSurveyPosition?

            if let obj = NSUserDefaults.standardUserDefaults().objectForKey("DemoAttachmentPosition") {
                position = QualarooSurveyPosition(rawValue: obj.unsignedIntegerValue)
            }

            if position == nil {
                // Set default attachment position based on platform
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    position = .BottomRight
                } else {
                    position = .Bottom
                }

                self.attachmentPosition = position!
            }

            return position!
        }

        set {
            NSUserDefaults.standardUserDefaults().setInteger(Int(newValue.rawValue), forKey: "DemoAttachmentPosition")

            showSurveyButton.enabled = false

            if let apiKey = apiKey {
                instantiateQualarooMobileWithAPIKey(apiKey)
            }
        }
    }

    var availableAttachmentPositions: [QualarooSurveyPosition] {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return [.BottomLeft, .BottomRight, .TopLeft, .TopRight]
        } else {
            return [.Bottom, .Top]
        }
    }
    
    var qualaroo: QualarooMobile?

    override func viewWillAppear(animated: Bool) {
        showSurveyButton.enabled = false
        apiKeyTextField.text = apiKey
        surveyIDTextField.text = String(surveyID)

        buildLabel.text = "\(QMBundleInfo.name()) \(QMBundleInfo.version()) (build \(QMBundleInfo.buildNumber()))\nBuilt on \(QMBundleInfo.buildDate())"

        buildLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        buildLabel.textAlignment = .Center
        buildLabel.textColor = .blackColor()
        buildLabel.lineBreakMode = .ByWordWrapping
        buildLabel.numberOfLines = 0

        if let idx = availableAttachmentPositions.indexOf(attachmentPosition) {
            attachmentPositionPickerView.selectRow(idx, inComponent: 0, animated: true)
        }

        if let apiKey = apiKey {
            instantiateQualarooMobileWithAPIKey(apiKey)
        }

        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        qualaroo?.removeFromViewController()
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }

    // MARK: UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableAttachmentPositions.count
    }

    // MARK: UIPickerViewDelegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let position = availableAttachmentPositions[safe: UInt(row)] {
            switch position {
            case .Top:
                return "Top"
            case .Bottom:
                return "Bottom"
            case .TopLeft:
                return "Top Left"
            case .TopRight:
                return "Top Right"
            case .BottomLeft:
                return "Bottom Left"
            case .BottomRight:
                return "Bottom Right"
            }
        } else {
            return nil
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let position = availableAttachmentPositions[safe: UInt(row)] {
            attachmentPosition = position
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label: UILabel! = view as? UILabel

        if label == nil {
            label = UILabel()

            label.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
            label.textAlignment = .Center
        }

        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)

        return label
    }

    // MARK: Actions

    @IBAction func updateAPIKey(sender: AnyObject) {
        apiKey = (sender as? UITextField)?.text
    }

    @IBAction func updateSurveyID(sender: AnyObject) {
        surveyID = UInt((sender as? UITextField)?.text ?? "") ?? 0
    }

    @IBAction func showSurvey(sender: AnyObject) {
        if qualaroo == nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.presentErrorMessage("Qualaroo Survey is not properly configured. Please enter a valid API Key.")
            }
        } else {
            qualaroo?.showSurvey(surveyID, force: true)
        }
    }

    // MARK: Private

    private func instantiateQualarooMobileWithAPIKey(APIKey: String) -> Bool {
        qualaroo?.removeFromViewController()
        qualaroo = nil

        do {
            qualaroo = try QualarooMobile(APIKey: APIKey)

            if let pvc = self.parentViewController {
                qualaroo?.attachToViewController(pvc, atPosition: attachmentPosition)
            }

            if surveyID != 0 {
                showSurveyButton.enabled = true
            }

            return true
        } catch {
            dispatch_async(dispatch_get_main_queue()) {
                self.presentErrorMessage("\((error as NSError).localizedDescription)")
            }

            return false
        }
    }

    private func presentErrorMessage(message: String) {
        let alertController = UIAlertController(title: "QualarooMobileSDK",
                                                message: message,
                                                preferredStyle: .Alert)

        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }

        alertController.addAction(okAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
}
