#### Integration Using Swift

1. Locate and open the source file for the view controller you would like to use as host and add:

    ```swift
    import QualarooMobileSDK
    ```

2. Instantiate `QualarooMobile`:

    ```swift
    lazy var qualaroo: QualarooMobile? = {
        do {
            return try QualarooMobile(apiKey: "YOUR-API-KEY-HERE")
        } catch {
            print("Error instantiating QualarooMobile: \(error)")
            return nil
        }
    }()
    ```

3. Attach the `QualarooMobile` instance to your view controller:

    ```swift
    override func viewDidAppear(animated: Bool) {
        qualaroo?.attach(to: self)

        super.viewDidAppear(animated)
    }
    ```

    Or, if you want to be more specific about the positioning:

    ```swift
    override func viewDidAppear(animated: Bool) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            qualaroo?.attach(to: self, at: .BottomRight)
        } else {
            qualaroo?.attachToViewController(self, atPosition: .Bottom)
        }

        super.viewDidAppear(animated)
    }
    ```

4. (Optional) You can set Identity Code by using any string.

    Identity Code default set as the device's UUID.

    ```swift
    qualaroo?.setIdentityCodeWith(_ YOUR_IDENTITY_STRING)
    ```

5. Manually trigger a survey:

    ```swift
    qualaroo?.showSurvey(_ YOUR_SURVEY_ALIAS)
    ```

    Or, overriding any targeting options used upon creation:

    ```swift
    qualaroo?.showSurvey(_ YOUR_SURVEY_ALIAS, force: true)
    ```

6. Removing `QualarooMobile` attachment from the hosting view controller:

    ```swift
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        qualaroo?.removeFromViewController()
    }
    ```
