//
//  ARGeoCoordinate.m
//  ARView
//
//  Created by Haseman on 01/08/2009.
//  Copyright 2009 Haseman. All rights reserved.
//  Modified by Zac White on 01/08/2009.
//  Modifications Copyright 2009 Zac White. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "ARGeoCoordinate.h"

@implementation ARGeoCoordinate

@synthesize coordinateGeoLocation;

- (id)initWithCoordiante:(CLLocation *)location andTitle:(NSString*)title {

	if ( self = [super init] ) {
		self.coordinateGeoLocation = location;
		self.coordinateTitle = title;
	}
	return self;
}

- (id)initWithCoordiante:(CLLocation *)location andOrigin:(CLLocation *)origin {
	
	if ( self = [super init] ) {
		self.coordinateGeoLocation = location;
		self.coordinateTitle = @"";
		[self calibrateUsingOrigin:origin];
	}
	return self;
}

- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	
	float longitudinalDifference = second.longitude - first.longitude;
	float latitudinalDifference	= second.latitude  - first.latitude;
	float possibleAzimuth = (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	
	if (longitudinalDifference > 0) 
		return possibleAzimuth;
	else if (longitudinalDifference < 0) 
		return possibleAzimuth + M_PI;
	else if (latitudinalDifference < 0) 
		return M_PI;
	
	return 0.0f;
}

- (void)calibrateUsingOrigin:(CLLocation *)origin {
	
	double baseDistance = [origin distanceFromLocation:self.coordinateGeoLocation];
	self.coordinateDistance = sqrt( pow(   [origin altitude] 
									     - [self.coordinateGeoLocation altitude], 2) 
									     + pow(baseDistance, 2) );
	
	float angle = sin(ABS([origin altitude] - [self.coordinateGeoLocation altitude]) / self.coordinateDistance);
	
	if ([origin altitude] > [self.coordinateGeoLocation altitude]) {
		angle = -angle;
	}

	self.coordinateInclination = angle;
	self.coordinateAzimuth = [self angleFromCoordinate:[origin coordinate] toCoordinate:[self.coordinateGeoLocation coordinate]];
	
	//NSLog(@"ARGeoCoordinate:calibrateUsingOrigin: (1) baseDistance is %.3f, angle is %.3f",baseDistance,angle);
	//NSLog(@"ARGeoCoordinate:calibrateUsingOrigin: (2) distance is %.3f, inclination is %.3f, azimuth is %.3f",self.coordinateDistance,self.coordinateInclination,radiansToDegrees(self.coordinateAzimuth));
}


@end
