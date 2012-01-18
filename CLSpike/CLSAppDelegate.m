//
//  CLSAppDelegate.m
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import "CLSAppDelegate.h"

#import "CLSMainViewController.h"

#include "JucheLog.h"
#import "Loggly.h"
#import "Loggly_API_Key.h"

@implementation CLSAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize locationManager = _locationManager;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainViewController = [[[CLSMainViewController alloc] initWithNibName:@"CLSMainViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
#ifdef kLOGGLY_API_KEY
    [Loggly enableWithInputKey:kLOGGLY_API_KEY];
#endif
    
    self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self performSelectorInBackground:@selector(performLaunchLogging) withObject:nil];
    [self performSelectorInBackground:@selector(performLaunchSetup) withObject:nil];
    return YES;
}

-(void) performLaunchLogging {
    NSLog(@"starting performLaunchLogging");
    NSDictionary *tempDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"timestamp", nil];
    JUCHE_LOG_DICT(JINFO, tempDict, @"Application Launched!");
    NSLog(@"ending performLaunchLogging");

}

-(void) performLaunchSetup { 
    NSLog(@"starting performLaunchSetup");
    
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
        // Get all regions being monitored for this application.
        NSArray *regions = [[[self.locationManager monitoredRegions] allObjects] copy];
        
        // Iterate through the regions and clean them up.
        for (int i = 0; i < [regions count]; i++) {
            CLRegion *region = [regions objectAtIndex:i];
            [self.locationManager stopMonitoringForRegion:region];
        }
        [regions release];
        //Now add our current region
	}
	else {
		JUCHE(JERROR,@"Significant location change monitoring is not available.");
	}
    
    [self.locationManager startUpdatingLocation];

    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    NSTimeInterval secondsSinceEpoch=[[NSDate date] timeIntervalSince1970];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",secondsSinceEpoch] ,@"timestamp", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    if ([CLLocationManager locationServicesEnabled]) {
        JUCHE_LOG_DICT(JINFO, tempDict, @"Successfully registered for location services"); 
    } else {
        JUCHE_LOG_DICT(JERROR, tempDict, @"Could not register for location services"); 
    }
    NSLog(@"ending performLaunchSetup");


}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
		[self.locationManager stopUpdatingLocation];
		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	else {
		JUCHE(JERROR,@"Significant location change monitoring is not available.");
	}

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
		[self.locationManager startUpdatingLocation];
	}
	else {
		JUCHE(JERROR, @"Significant location change monitoring is not available.");
	}

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager didFailWithError:%@",error.description);

	JUCHE(JERROR,@"didFailWithError: %@", [error description]);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"locationManager didUpdateToLocation:%@",newLocation);
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    if (oldLocation) {
        JUCHE_LOG_DICT(JINFO, tempDict,@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    } else {
        JUCHE_LOG_DICT(JINFO, tempDict,@"didUpdateToLocation %@", newLocation);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber++;

    [self addRegionAroundLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
	NSString *event = [NSString stringWithFormat:@"didEnterRegion %@ at %@", region.identifier, [NSDate date]];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",region.center.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",region.center.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    JUCHE_LOG_DICT(JINFO, tempDict,@"didEnterRegion: %@", event);

}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	NSString *event = [NSString stringWithFormat:@"didExitRegion %@ at %@", region.identifier, [NSDate date]];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",region.center.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",region.center.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    JUCHE_LOG_DICT(JINFO, tempDict,@"didExitRegion: %@", event);
    [UIApplication sharedApplication].applicationIconBadgeNumber++;

    [self.locationManager startUpdatingLocation];
    [self.locationManager stopMonitoringForRegion:region];
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
    JUCHE(JERROR,@"monitoringDidFailForRegion: %@", event);

}


- (IBAction)addRegionAroundLocation:(CLLocation *)newLocation {
    [UIApplication sharedApplication].applicationIconBadgeNumber++;

	if ([CLLocationManager regionMonitoringAvailable]) {
		// Create a new region based on the center of the map view.
		CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:newLocation.coordinate 
																	  radius:100.0 
																  identifier:[NSString stringWithFormat:@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
        
        NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];
		
        JUCHE_LOG_DICT(JINFO, tempDict,@"addedRegion: %@", [NSString stringWithFormat:@"%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
		// Start monitoring the newly created region.
		[self.locationManager startMonitoringForRegion:newRegion desiredAccuracy:kCLLocationAccuracyBest];
		
		[newRegion release];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}


@end
