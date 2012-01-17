//
//  CLSFlipsideViewController.h
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLSFlipsideViewController;

@protocol CLSFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CLSFlipsideViewController *)controller;
@end

@interface CLSFlipsideViewController : UIViewController

@property (assign, nonatomic) IBOutlet id <CLSFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
