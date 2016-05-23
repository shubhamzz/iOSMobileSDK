//
//  QMTypes.h
//  QualarooMobileSDK
//
//  Created by Ruben Nine on 02/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

#ifndef QMTypes_h
#define QMTypes_h

@import Foundation;

/**
   `QualarooSurveyPosition` enumerates all the supported attachment positions for a Qualaroo Mobile
   survey.
 
   @note Please notice supported positions vary depending on the platform. 
 */
typedef NS_ENUM(NSUInteger, QualarooSurveyPosition) {
    /**
       Attach survey at the top of the host controller's view
     
       @note iPhone only
     */
    QualarooSurveyPositionTop,

    /**
       Attach survey at the bottom of the host controller's view

       @note iPhone only
     */
    QualarooSurveyPositionBottom,

    /**
       Attach survey at the top left corner of the host controller's view

       @note iPad only
     */
    QualarooSurveyPositionTopLeft,

    /**
       Attach survey at the top right corner of the host controller's view

       @note iPad only
     */
    QualarooSurveyPositionTopRight,

    /**
       Attach survey at the bottom left corner of the host controller's view

       @note iPad only
     */
    QualarooSurveyPositionBottomLeft,

    /**
       Attach survey at the bottom right corner of the host controller's view

       @note iPad only
     */
    QualarooSurveyPositionBottomRight
};

#endif /* QMTypes_h */
