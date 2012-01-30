//
//  ARController.h
//  ARView
//
//  Created by Alasdair Allan on 07/04/2010.
//  Copyright 2010 Babilim Light Industries. All rights reserved.
//  Based on work by Zac White and Niels Hansen, 2009
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@class ARCoordinate;
@class ARGeoCoordinate;

@interface ARController : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate>  {

	UIDeviceOrientation currentOrientation;
	CLLocation *currentLocation;
	CLHeading *currentHeading;
	ARCoordinate *currentCoordinate;
	
	double viewRange;
	double viewAngle;

	UIViewController *rootController;
	UIImagePickerController	*pickerController;
	UIView *overlayView;
    UIView *originalView;

	CLLocationManager *locationManager;
	UIAccelerometer	*accelerometer;
	
	NSMutableArray *coordinates;
	
}

@property (nonatomic) UIDeviceOrientation currentOrientation;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLHeading *currentHeading;
@property (nonatomic, retain) ARCoordinate *currentCoordinate;

@property (nonatomic) double viewRange;
@property (nonatomic) double viewAngle;

@property (nonatomic, retain) UIViewController *rootController;
@property (nonatomic, retain) UIImagePickerController *pickerController;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *originalView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIAccelerometer *accelerometer;


- (id)initWithViewController:(UIViewController *)theView;
- (void)presentModalARControllerAnimated:(BOOL)animated;
- (void) dismissModalARControllerAnimated:(BOOL) animated;

- (void)addCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;
- (void)removeCoordinate:(ARCoordinate *)coordinate animated:(BOOL)animated;

@end

@interface ARController (Private)

- (void)updateCurrentCoordinate;
- (void)updateCurrentLocation:(CLLocation *)newLocation;
- (void)updateLocations;

- (BOOL)viewportContainsCoordinate:(ARCoordinate *)coordinate;
- (double)deltaAzimuthForCoordinate:(ARCoordinate *)coordinate;
- (CGPoint)pointForCoordinate:(ARCoordinate *)coordinate;
- (BOOL)isNorthForCoordinate:(ARCoordinate *)coordinate;

@end
