//
//  ARCoordinate.h
//  ARView
//
//  Created by Zac White on 01/08/2009.
//  Copyright 2009 Zac White. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARMarker;

@interface ARCoordinate : NSObject {
	double coordinateDistance;
	double coordinateInclination;
	double coordinateAzimuth;
	NSString *coordinateTitle;
	NSString *coordinateSubTitle;
	ARMarker *coordinateMarker;
}

- (id)initWithRadialDistance:(double)distance andInclination:(double)inclination andAzimuth:(double)azimuth;

@property (nonatomic, retain) NSString *coordinateTitle;
@property (nonatomic, retain) NSString *coordinateSubTitle;
@property (nonatomic) double coordinateDistance;
@property (nonatomic) double coordinateInclination;	
@property (nonatomic) double coordinateAzimuth;	
@property (nonatomic, retain) ARMarker *coordinateMarker;	

@end
