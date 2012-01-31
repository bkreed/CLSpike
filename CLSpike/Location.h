//
//  Location.h
//  CLSpike
//
//  Created by Carl Brown on 1/30/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic) float battery_status;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic) double altitude;
@property (nonatomic) double course;
@property (nonatomic) double speed;
@property (nonatomic) double horizontalAccuracy;
@property (nonatomic) double verticalAccuracy;

@end
