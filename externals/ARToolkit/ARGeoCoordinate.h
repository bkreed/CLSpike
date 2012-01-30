//
//  ARGeoCoordinate.h
//  ARView
//
//  Created by Haseman on 01/08/09.
//  Copyright 2009 Haseman. All rights reserved.
//  Modified by Zac White on 01/08/2009.
//  Modifications Copyright 2009 Zac White. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ARCoordinate.h"

@interface ARGeoCoordinate : ARCoordinate {
	CLLocation *coordinateGeoLocation;
}

@property (nonatomic, retain) CLLocation *coordinateGeoLocation;

- (id)initWithCoordiante:(CLLocation *)location andTitle:(NSString*)title;
- (id)initWithCoordiante:(CLLocation *)location andOrigin:(CLLocation *)origin;

- (void)calibrateUsingOrigin:(CLLocation *)origin;
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;

@end
