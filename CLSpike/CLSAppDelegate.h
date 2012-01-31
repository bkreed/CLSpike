//
//  CLSAppDelegate.h
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class CLSMainViewController;

@interface CLSAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLSMainViewController *mainViewController;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) CLLocation *lastLocation;


-(void) performLaunchSetup;
-(void) performLaunchLogging;

- (IBAction)addRegionAroundLocation:(CLLocation *)newLocation;
@end
