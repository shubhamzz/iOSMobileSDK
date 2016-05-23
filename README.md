# QualarooMobileSDK

## Requirements

In order to integrate the `QualarooMobileSDK` into a 3rd-party app, the app must satisfy the following requirements:

- Minimum deployment target set to iOS 8.0 or later
- Xcode 6 or later

## Integration

Integrating and keeping our SDK up-to-date on any of your iOS apps can be as simple as adding one line to your `Carthage` file (highly recommended) and then adding a few lines into your app's source.

For those that would rather avoid any dependency manager or that would like to manually set up their project dependencies, we will also describe an alternative method based on [git submodules](https://git-scm.com/docs/git-submodule).

### Using Carthage

1. Add `github "qualaroo/QualarooMobileSDK" ~> 1.0` to your `Carthage` file.
2. Run `carthage update`
3. Open your Xcode project and add `QualarooMobileSDK.framework` as an embedded framework on your app's target.

To keep our SDK up-to-date, you will typically only need to run `carthage update`. If you need a more comprehensive guide on maintaining Carthage dependencies, please refer to [this guide](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).


### Using as Git Submodule

You probably already know what you are doing if you are following this method, but if you need a guideline, here's a possible procedure:

1. Run `git submodule add github.com:qualaroo/QualarooMobileSDK.git`
2. *(optionally)* Checkout a specific tag:
	- ```
	cd path/to/your/submodule
	git checkout 1.0
	cd .. # back to your SRCROOT
	git commit -m "Using QualarooMobileSDK 1.0"
	```
3. Open your Xcode project and add `QualarooMobileSDK.framework` as an embedded framework on your app's target.

### Code Integration

**Important:** Our SDK requires a hosting view controller where any Qualaroo Mobile surveys will be displayed.

The typical integration procedure is as follows:

1. Import `QualarooMobileSDK` into your code (e.g., a view controller)
2. Instantiate `QualarooMobile` by passing a valid API key and check for any errors (instantiation may fail due to an invalid/bogus API key)
3. Attach the `QualarooMobile` instance to your view controller and, optionally, specify an attachment position (bottom or top on iPhone, or a corner on iPad)
4. Show a survey with a given ID.
5. Cleanup: Remove `QualarooMobile` from the hosting view controller.

**Note**: It is very important to remember removing the `QualarooMobile` attachment from the hosting view controller whenever it is no longer necessary and before the view controller is destroyed, otherwise we will incur into a retain cycle.

Let's now proceed with examples using Swift and Objective-C:

#### Using Swift

1. Locate and open the source file for the view controller you would like to use as host and add: 
    - ```
    	import QualarooMobileSDK
      ```
2. Instantiate `QualarooMobile`:
	- ```
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
    - ```
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
     - ```
    	 qualaroo?.showSurvey(YOUR_SURVEY_ID)
     ```
     
     **Important:** If you want to force a survey to display overriding the targeting options used upon creation, you may instead use:
     
     - ```
	     qualaroo?.showSurvey(YOUR_SURVEY_ID, force: true)
     ```
  5. Removing `QualarooMobile` attachment from the hosting view controller:
     - ```
        override func viewDidDisappear(animated: Bool) {
        	qualaroo?.removeFromViewController()
        	
    	    super.viewDidDisappear(animated)
        }
       ```
     
#### Using Objective-C

PENDING

## Further SDK Documentation

Please refer to the documentation available [here](https://somelink).

## License

PENDING: Some license goes here.