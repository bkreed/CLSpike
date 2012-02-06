//
//  CLSAppDelegate.m
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import "CLSAppDelegate.h"

#import "CLSMainViewController.h"

#import "CoreData+MagicalRecord.h"

#include "JucheLog.h"
#import "Loggly.h"
#import "Loggly_API_Key.h"

#import "Location.h"

#define kRequiredAccuracy 1000
#define kRequiredRecency  -300

@implementation CLSAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize locationManager = _locationManager;
@synthesize dateFormatter = _dateFormatter;
@synthesize lastLocation = _lastLocation;

- (void)dealloc
{
    [_window release];
    [_mainViewController release];
    [_locationManager release];
    [_dateFormatter release];
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
    
    CLLocationManager *cl = [[CLLocationManager alloc] init];
    
	cl.delegate = self;
	cl.distanceFilter = kCLLocationAccuracyNearestTenMeters;
	cl.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self setLocationManager:cl];
    [cl release];

    [self performSelectorInBackground:@selector(performLaunchLogging) withObject:nil];
    [self performSelectorInBackground:@selector(performLaunchSetup) withObject:nil];
    [MagicalRecordHelpers setupAutoMigratingCoreDataStack];
    return YES;
}

-(void) performLaunchLogging {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"starting performLaunchLogging");
    NSDictionary *tempDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"timestamp", nil];
    JUCHE_LOG_DICT(JINFO, tempDict, @"Application Launched!");
    NSLog(@"ending performLaunchLogging");

    [pool drain];
}

-(void) performLaunchSetup { 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"starting performLaunchSetup");
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateFormat:@"M/dd hh:mma"];
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    NSTimeInterval secondsSinceEpoch=[[NSDate date] timeIntervalSince1970];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",secondsSinceEpoch] ,@"timestamp", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusRestricted) {
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
        
        [self.locationManager performSelectorOnMainThread:@selector(startUpdatingLocation) withObject:nil waitUntilDone:YES];
        
        if ([CLLocationManager locationServicesEnabled]) {
            JUCHE_LOG_DICT(JINFO, tempDict, @"Successfully registered for location services"); 
        } else {
            JUCHE_LOG_DICT(JERROR, tempDict, @"Could not register for location services"); 
        }

    } else {
        JUCHE(JERROR,@"Location change monitoring is not authorized.");
    }

    NSLog(@"ending performLaunchSetup");

    [pool drain];

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
	
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusRestricted) {
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            // Stop normal location updates and start significant location change updates for battery efficiency.
            [self.locationManager stopUpdatingLocation];
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
        else {
            JUCHE(JERROR,@"Significant location change monitoring is not available.");
        }
    } else {
        JUCHE(JERROR,@"Location change monitoring is not authorized.");
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
    if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusDenied && [CLLocationManager authorizationStatus]!=kCLAuthorizationStatusRestricted) {
        if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
            // Stop significant location updates and start normal location updates again since the app is in the forefront.
            [self.locationManager stopMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
        }
        else {
            JUCHE(JERROR, @"Significant location change monitoring is not available.");
        }
    } else {
        JUCHE(JERROR,@"Location change monitoring is not authorized.");
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
    [MagicalRecordHelpers cleanUp];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"locationManager didFailWithError:%@",error.description);

	JUCHE(JERROR,@"didFailWithError: %@", [error description]);
    
    [pool drain];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation ==nil) {
        return;
    }
    
    if (newLocation.horizontalAccuracy > kRequiredAccuracy) {
        //too fuzzy - skip it
        return;
    }
    
    NSDate *dateThreshold=[NSDate dateWithTimeIntervalSinceNow:kRequiredRecency];
    NSDate *locationsDate = [newLocation timestamp];
    if ([dateThreshold compare:locationsDate]==NSOrderedDescending) {
        //Too old - skip it
        return;
    }
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSLog(@"locationManager didUpdateToLocation:%@",newLocation);
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",newLocation.coordinate.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    if (oldLocation) {
        JUCHE_LOG_DICT(JINFO, tempDict,@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    } else {
        JUCHE_LOG_DICT(JINFO, tempDict,@"didUpdateToLocation %@", newLocation);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    self.lastLocation = newLocation;

    [self addRegionAroundLocation:newLocation];
    [self.locationManager stopUpdatingLocation];
    Location *newLocationObject = [Location createInContext:[NSManagedObjectContext contextForCurrentThread]];
    [newLocationObject setLatitude:newLocation.coordinate.latitude];
    [newLocationObject setLongitude:newLocation.coordinate.longitude];
    [newLocationObject setTimestamp:[NSDate date]];
    [newLocationObject setBattery_status:[[UIDevice currentDevice] batteryLevel]];
    [newLocationObject setSpeed:newLocation.speed];
    [newLocationObject setCourse:newLocation.course];
    [newLocationObject setHorizontalAccuracy:newLocation.horizontalAccuracy];
    [newLocationObject setVerticalAccuracy:newLocation.verticalAccuracy];
    [newLocationObject setAltitude:newLocation.altitude];
    NSError *error=nil;
    if (![[NSManagedObjectContext contextForCurrentThread] save:&error]) {
        NSLog(@"Error saving: %@",[error description]);
    }

    [pool drain];

}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region  {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *event = [NSString stringWithFormat:@"didEnterRegion %@ at %@", region.identifier, [NSDate date]];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",region.center.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",region.center.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    JUCHE_LOG_DICT(JINFO, tempDict,@"didEnterRegion: %@", event);
    [pool drain];

}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *event = [NSString stringWithFormat:@"didExitRegion %@ at %@", region.identifier, [NSDate date]];
    NSDictionary *tempDict= [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] ,@"timestamp", [NSString stringWithFormat:@"%+.8f",region.center.latitude], @"latitude", [NSString stringWithFormat:@"%+.8f",region.center.longitude], @"longitude", [NSString stringWithFormat:@"%.2f", [[UIDevice currentDevice] batteryLevel]], @"battery_level", nil];

    JUCHE_LOG_DICT(JINFO, tempDict,@"didExitRegion: %@", event);
    [UIApplication sharedApplication].applicationIconBadgeNumber++;

    [self.locationManager startUpdatingLocation];
    [self.locationManager stopMonitoringForRegion:region];
    [pool drain];

}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString *event = [NSString stringWithFormat:@"monitoringDidFailForRegion %@: %@", region.identifier, error];
    JUCHE(JERROR,@"monitoringDidFailForRegion: %@", event);
    [pool drain];


}


- (IBAction)addRegionAroundLocation:(CLLocation *)newLocation {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

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
    [pool drain];

}


@end
