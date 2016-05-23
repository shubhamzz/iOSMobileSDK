#### Integration Using Swift

1. Locate and open the source file for the view controller you would like to use as host and add:

    ```swift
    import QualarooMobileSDK
    ```

2. Instantiate `QualarooMobile`:

    ```swift
    var qualaroo: QualarooMobile? {
        do {
            return try QualarooMobile(APIKey: "YOUR-API-KEY-HERE")
        } catch {
            print("Error instantiating QualarooMobile: \(error)")
            return nil
        }
    }
    ```

3. Attach the `QualarooMobile` instance to your view controller:

    ```swift
    override func viewDidAppear(animated: Bool) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            qualaroo?.attachToViewController(self, atPosition: .BottomRight)
        } else {
            qualaroo?.attachToViewController(self, atPosition: .Bottom)
        }

        super.viewDidAppear(animated)
    }
    ```

4. Manually trigger a survey:

    ```swift
    qualaroo?.showSurvey(YOUR_SURVEY_ID)
    ```

    ... or, overriding any targeting options used upon creation:

    ```swift
    qualaroo?.showSurvey(YOUR_SURVEY_ID, force: true)
    ```

5. Removing `QualarooMobile` attachment from the hosting view controller:

    ```swift
    override func viewDidDisappear(animated: Bool) {
        qualaroo?.removeFromViewController()

        super.viewDidDisappear(animated)
    }
    ```
