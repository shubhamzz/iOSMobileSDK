#### Integration Using Objective-C

1. Locate and open the source file for the view controller you would like to use as host and add:

    ```objective-c
    @import QualarooMobileSDK;
    ```

2. Instantiate `QualarooMobile`:

    ```objective-c
    NSError *error;

    self.qualaroo = [[QualarooMobile alloc] initWithAPIKey:@"YOUR-API-KEY"
                                                     error:&error];

    if (error) {
        // An error occurred upon instantiation, handle appropriately
    }
    ```

3. Attach the `QualarooMobile` instance to your view controller:

    ```objective-c
	 - (void)viewDidAppear:(BOOL)animated {
	     [self.qualaroo attachToViewController:self];

	     [super viewDidAppear:animated];
	 }
    ```

    Or, if you want to be more specific about the positioning:

    ```objective-c
	 - (void)viewDidAppear:(BOOL)animated {
	     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
	         [self.qualaroo attachToViewController:self
	                                   atPosition:QualarooSurveyPositionBottomRight];
	     } else {
	         [self.qualaroo attachToViewController:self
	                                    atPosition:QualarooSurveyPositionBottom];
	    }

	     [super viewDidAppear:animated];
	 }
    ```

4. (Optional) You can set Identity Code by using any string.

    Identity Code default set as the device's UUID.

    ```objective-c
    [self.qualaroo setIdentityCodeWith:YOUR_IDENTITY_STRING];
    ```

5. Manually trigger a survey:

    ```objective-c
    [self.qualaroo showSurvey:YOUR_SURVEY_ALIAS];
    ```

    Or, overriding any targeting options used upon creation:

    ```objective-c
    [self.qualaroo showSurvey:YOUR_SURVEY_ALIAS force:YES];
    ```

6. Removing `QualarooMobile` attachment from the hosting view controller:

    ```objective-c
	 - (void)viewDidDisappear:(BOOL)animated {
	     [super viewDidDisappear:animated];

	     [self.qualaroo removeFromViewController];
	 }
    ```
