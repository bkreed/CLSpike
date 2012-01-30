//
//  Location.h
//  CLSpike
//
//  Created by Carl Brown on 1/30/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+MagicalRecord.h"

@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * battery_status;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * timestamp;

@end
