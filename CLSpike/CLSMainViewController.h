//
//  CLSMainViewController.h
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import "CLSFlipsideViewController.h"

@class ARController;

@interface CLSMainViewController : UIViewController <CLSFlipsideViewControllerDelegate> 

@property (nonatomic, retain) ARController *arController;

- (IBAction)showInfo:(id)sender;
- (IBAction)startAR:(id)sender;
- (IBAction) closeButtonClicked: (id) sender;

@end
