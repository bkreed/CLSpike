//
//  ARMarker.h
//  ARView
//
//  Created by Niels W Hansen on 19/12/2009.
//  Copyright 2009 Agilite Software. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ARCoordinate;

@interface ARMarker : UIView {

}

- (id)initForCoordinate:(ARCoordinate *)coordinate;

@end
