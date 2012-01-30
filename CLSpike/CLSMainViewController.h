//
//  CLSMainViewController.h
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import "CLSFlipsideViewController.h"

@interface CLSMainViewController : UIViewController <CLSFlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (retain, nonatomic) IBOutlet 
    UITableView *tableView;
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)showInfo:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
