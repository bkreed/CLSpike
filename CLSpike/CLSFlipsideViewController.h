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

@interface CLSFlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) IBOutlet id <CLSFlipsideViewControllerDelegate> delegate;
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)done:(id)sender;

@end
