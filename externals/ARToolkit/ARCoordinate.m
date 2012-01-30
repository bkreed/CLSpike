//
//  ARCoordinate.m
//  ARView
//
//  Created by Zac White on 01/08/2009.
//  Copyright 2009 Zac White. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "ARCoordinate.h"

@implementation ARCoordinate

@synthesize coordinateTitle;
@synthesize coordinateSubTitle;
@synthesize coordinateDistance;
@synthesize coordinateInclination;	
@synthesize coordinateAzimuth;
@synthesize coordinateMarker;

// Override the coordinateAzimuth accessor method
- (double)coordinateAzimuth {
	if ( coordinateAzimuth < 0.0 ) {
		coordinateAzimuth = (M_PI * 2.0) + coordinateAzimuth;
	} else if ( coordinateAzimuth > (M_PI * 2.0) ) {
		coordinateAzimuth = coordinateAzimuth - (M_PI * 2.0);
	}
	return coordinateAzimuth;
}


- (id)initWithRadialDistance:(double)distance andInclination:(double)inclination andAzimuth:(double)azimuth {
	if ( self = [super init] ) {
		self.coordinateDistance = distance;
		self.coordinateInclination = inclination;
		self.coordinateAzimuth = azimuth;
	}
	return self;
}

- (void)dealloc {
	
	[self coordinateTitle];
	[self coordinateSubTitle];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ r: %.3fm φ: %.3f° θ: %.3f°", [self coordinateTitle], [self coordinateDistance], radiansToDegrees([self coordinateAzimuth]), radiansToDegrees([self coordinateInclination])];
}

@end
