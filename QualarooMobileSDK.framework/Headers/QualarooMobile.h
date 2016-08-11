//
//  QualarooMobile.h
//  QualarooMobileSDK
//
//  Created by Ruben Nine on 02/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

@import UIKit;
#import "QMTypes.h"

@class QualarooMobile;

NS_ASSUME_NONNULL_BEGIN

/**
   `QualarooMobile` provides an easy interface to attach, remove and display Qualaro Mobile surveys
   inside a view controller.
 */
@interface QualarooMobile : NSObject

/**
   Unavailable: Please use the designated initializer instead.
   :nodoc:
 */
- (nullable instancetype)init NS_UNAVAILABLE;

/**
   Designated initializer.

   @param APIKey The API key from Qualaroo.
   @param outError A pointer to an NSError. In case initialization fails, an error will be returned.
 */
- (nullable instancetype)initWithAPIKey:(NSString *)APIKey
                                  error:(NSError **)outError NS_DESIGNATED_INITIALIZER;

/**
   Attaches Qualaroo's survey view controller to a given view controller.

   @see -attachToViewController:atPosition:
 */
- (BOOL)attachToViewController:(UIViewController *)viewController;

/**
   Attaches Qualaroo's survey view controller to a given view controller and position.

   @param viewController The view controller that will be used to host surveys.
   @param position The attachment position (see `QualarooSurveyPosition` for supported positions)

   @see -attachToViewController:
 */
- (BOOL)attachToViewController:(UIViewController *)viewController atPosition:(QualarooSurveyPosition)position;

/**
   Removes a previously attached survey from a view controller.
 */
- (BOOL)removeFromViewController;

/**
 
 @brief Displays a survey with a given Alias inside a view controller.
 
 @param surveyAlias The survey Alias to display.
 */
- (void)showSurvey:(NSString *)surveyAlias;

/**
   Displays a survey with a given Alias inside a view controller.

   @param surveyAlias The survey Alias to display.
   @param shouldForce Force a survey to show overriding target settings.
 */
- (void)showSurvey:(NSString *)surveyAlias force:(BOOL)shouldForce;

@end

NS_ASSUME_NONNULL_END
