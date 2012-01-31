//
//  CLSFlipsideViewController.h
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CLSFlipsideViewController;

@protocol CLSFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CLSFlipsideViewController *)controller;
@end

@interface CLSFlipsideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) IBOutlet id <CLSFlipsideViewControllerDelegate> delegate;
@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)switchViews: (id) sender;
- (IBAction)done:(id)sender;

@end
