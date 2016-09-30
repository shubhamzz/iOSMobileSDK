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

    var surveyAlias: String? {
        get {
            return UserDefaults.standard.string(forKey: "DemoSurvey")
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "DemoSurvey")

            if qualaroo != nil && newValue != "" {
                showSurveyButton.isEnabled = true
            } else {
                showSurveyButton.isEnabled = false
            }
        }
    }

    var apiKey: String? {
        get {
            return UserDefaults.standard.string(forKey: "DemoAPIKey")
        }

        set {
            UserDefaults.standard.set(newValue, forKey: "DemoAPIKey")

            showSurveyButton.isEnabled = false

            if let newValue = newValue {
                _ = instantiateQualarooMobileWithAPIKey(newValue)
            }
        }
    }

    var attachmentPosition: QualarooSurveyPosition {
        get {
            var position: QualarooSurveyPosition?

            if let obj = UserDefaults.standard.object(forKey: "DemoAttachmentPosition") {
                position = QualarooSurveyPosition(rawValue: (obj as AnyObject).uintValue)
            }

            if position == nil {
                // Set default attachment position based on platform
                if UIDevice.current.userInterfaceIdiom == .pad {
                    position = .bottomRight
                } else {
                    position = .bottom
                }

                self.attachmentPosition = position!
            }

            return position!
        }

        set {
            UserDefaults.standard.set(Int(newValue.rawValue), forKey: "DemoAttachmentPosition")

            showSurveyButton.isEnabled = false

            if let apiKey = apiKey {
                _ = instantiateQualarooMobileWithAPIKey(apiKey)
            }
        }
    }

    var availableAttachmentPositions: [QualarooSurveyPosition] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [.bottomLeft, .bottomRight, .topLeft, .topRight]
        } else {
            return [.bottom, .top]
        }
    }
    
    var qualaroo: QualarooMobile?

    override func viewWillAppear(_ animated: Bool) {
        showSurveyButton.isEnabled = false
        apiKeyTextField.text = apiKey
        if let surveyAlias = surveyAlias {
            surveyIDTextField.text = surveyAlias
        } else {
            surveyIDTextField.text = ""
        }

        guard let bundleInfoName = QMBundleInfo.name(),
              let bundleInfoVersion = QMBundleInfo.version(),
              let buildInfoNumber = QMBundleInfo.buildNumber(),
              let buildInfoDate = QMBundleInfo.buildDate()
        else { return }
        
        buildLabel.text = "\(bundleInfoName) \(bundleInfoVersion) (build \(buildInfoNumber))\nBuilt on \(buildInfoDate)"

        buildLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        buildLabel.textAlignment = .center
        buildLabel.textColor = .black
        buildLabel.lineBreakMode = .byWordWrapping
        buildLabel.numberOfLines = 0

        if let idx = availableAttachmentPositions.index(of: attachmentPosition) {
            attachmentPositionPickerView.selectRow(idx, inComponent: 0, animated: true)
        }

        if let apiKey = apiKey {
            _ = instantiateQualarooMobileWithAPIKey(apiKey)
        }

        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        qualaroo?.removeFromViewController()
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }

    // MARK: UIPickerViewDataSource

    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableAttachmentPositions.count
    }

    // MARK: UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let position = availableAttachmentPositions[safe: UInt(row)] {
            switch position {
            case .top:
                return "Top"
            case .bottom:
                return "Bottom"
            case .topLeft:
                return "Top Left"
            case .topRight:
                return "Top Right"
            case .bottomLeft:
                return "Bottom Left"
            case .bottomRight:
                return "Bottom Right"
            }
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let position = availableAttachmentPositions[safe: UInt(row)] {
            attachmentPosition = position
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel! = view as? UILabel

        if label == nil {
            label = UILabel()

            label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            label.textAlignment = .center
        }

        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)

        return label
    }

    // MARK: Actions

    @IBAction func updateAPIKey(_ sender: AnyObject) {
        apiKey = (sender as? UITextField)?.text
    }

    @IBAction func updateSurveyID(_ sender: AnyObject) {
        surveyAlias = (sender as? UITextField)?.text ?? ""
    }

    @IBAction func showSurvey(_ sender: AnyObject) {
        if qualaroo == nil {
            DispatchQueue.main.async {
                self.presentErrorMessage("Qualaroo Survey is not properly configured. Please enter a valid API Key.")
            }
        } else {
            guard let surveyAlias = surveyAlias else { return }
            qualaroo?.showSurvey(surveyAlias, force: true)
        }
    }

    // MARK: Private

    fileprivate func instantiateQualarooMobileWithAPIKey(_ APIKey: String) -> Bool {
        qualaroo?.removeFromViewController()
        qualaroo = nil

        do {
            qualaroo = try QualarooMobile(apiKey: APIKey)

            if let pvc = self.parent {
                qualaroo?.attach(to: pvc, at: attachmentPosition)
            }

            if surveyAlias != "" {
                showSurveyButton.isEnabled = true
            }

            return true
        } catch {
            DispatchQueue.main.async {
                self.presentErrorMessage("\((error as NSError).localizedDescription)")
            }

            return false
        }
    }

    fileprivate func presentErrorMessage(_ message: String) {
        let alertController = UIAlertController(title: "QualarooMobileSDK",
                                                message: message,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
