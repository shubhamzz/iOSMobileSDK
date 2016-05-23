//
//  QMBundleInfo.h
//  QualarooMobileSDK
//
//  Created by Ruben Nine on 02/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

@import Foundation;

/**
   `QMBundleInfo` provides build information about `QualarooMobileSDK` such as: bundle name, version,
   build number and build date.
 */
@interface QMBundleInfo : NSObject

/**
   Unavailable: This class is not instantiable.
   :nodoc:
 */
- (instancetype)init NS_UNAVAILABLE;

/**
   The bundle name.
 */
+ (NSString *)name;

/**
   The version of the SDK.
 */
+ (NSString *)version;

/**
   The build number of the SDK.
 */
+ (NSString *)buildNumber;

/**
   The build date of the SDK.
 */
+ (NSString *)buildDate;

/**
   A description of the SDK build information by combining name, version, build number and build date.
 */
+ (NSString *)description;

@end
