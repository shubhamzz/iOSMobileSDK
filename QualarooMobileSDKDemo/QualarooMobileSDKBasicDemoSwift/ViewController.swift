//
//  ViewController.swift
//  QualarooMobileSDKBasicDemoSwift
//
//  Created by Ruben Nine on 25/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

import UIKit
import QualarooMobileSDK

class ViewController: UIViewController {

    lazy var qualaroo: QualarooMobile? = {
        do {
            // 1 - Set your API key below
            return try QualarooMobile(APIKey: "YOUR-API-KEY")
        } catch {
            print("Error instantiating QualarooMobile due to: \((error as NSError).localizedDescription).")

            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        qualaroo?.attachToViewController(self)

        super.viewDidAppear(animated)

        // 2 - Set your survey ID below
        qualaroo?.showSurvey(0, force: true)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        qualaroo?.removeFromViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

