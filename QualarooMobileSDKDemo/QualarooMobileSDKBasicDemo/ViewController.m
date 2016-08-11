//
//  ViewController.m
//  QualarooMobileSDKBasicDemo
//
//  Created by Ruben Nine on 25/05/16.
//  Copyright © 2016 Qualaroo. All rights reserved.
//

#import "ViewController.h"
@import QualarooMobileSDK;

@interface ViewController ()

@property (nonatomic, strong) QualarooMobile *qualaroo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSError *error;

    // 1 - Set your API key below
    self.qualaroo = [[QualarooMobile alloc] initWithAPIKey:@"YOUR-API-KEY"
                                                     error:&error];

    if (error) {
        NSLog(@"ERROR: Unable to instantiate QualarooMobile due to: %@.", error.localizedDescription);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self.qualaroo attachToViewController:self];

    [super viewDidAppear:animated];

    // 2 - Set your survey ID or Alias below
    [self.qualaroo showSurvey:@""
                        force:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.qualaroo removeFromViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
