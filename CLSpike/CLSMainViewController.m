//
//  CLSMainViewController.m
//  CLSpike
//
//  Created by Carl Brown on 1/12/12.
//  Copyright (c) 2012 PDAgent, LLC. All rights reserved.
//

#import "CLSMainViewController.h"
#import "Location.h"
#import "ARController.h"
#import "ARGeoCoordinate.h"
#import "CLSAppDelegate.h"

//If it's less than this far away, don't try to show it in the AR view
#define kMinDistance 5

//If it's less sure than this, don't try to show it in the ArView
#define kMinAccuracy 150

@implementation CLSMainViewController

@synthesize arController = _arController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(CLSFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    CLSFlipsideViewController *controller = [[[CLSFlipsideViewController alloc] initWithNibName:@"CLSFlipsideViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)startAR:(id)sender {
    self.arController = [[[ARController alloc] initWithViewController:self] autorelease];
    
    CLSAppDelegate *appDelegate = (CLSAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    NSPredicate *closeFilter = [NSPredicate predicateWithFormat:@"horizontalAccuracy < %d",kMinAccuracy];

    NSFetchRequest *locFetcher = [Location requestAllSortedBy:@"timestamp" 
                                                    ascending:NO 
                                                    withPredicate:closeFilter
                                                    inContext:[NSManagedObjectContext contextForCurrentThread]];
    [locFetcher setFetchLimit:30];
    for (Location *loc in [Location executeFetchRequest:locFetcher]) {
        CLLocation *fetchedLocation = [[[CLLocation alloc] initWithLatitude:[loc.latitude doubleValue] longitude:[loc.longitude doubleValue]] autorelease];
        ARGeoCoordinate *tempCoordinate = [[ARGeoCoordinate alloc] initWithCoordiante:fetchedLocation andTitle: [appDelegate.dateFormatter stringFromDate:loc.timestamp]];

        [self.arController addCoordinate:tempCoordinate animated:NO];
        [tempCoordinate release];

    }
    
	[self.arController presentModalARControllerAnimated:NO];

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    
    [closeBtn setBackgroundColor:[UIColor greenColor]];
    [closeBtn addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:closeBtn];
    
    [closeBtn release];

}

- (IBAction) closeButtonClicked: (id) sender {
    [self.arController dismissModalARControllerAnimated:NO];
    [(UIButton *) sender removeFromSuperview];
    [self setArController:nil];
}
  
- (void)dealloc {
    [super dealloc];
}
@end
