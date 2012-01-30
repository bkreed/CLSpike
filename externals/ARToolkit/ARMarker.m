//
//  ARMarker.m
//  ARView
//
//  Created by Niels W Hansen on 19/12/2009.
//  Copyright 2009 Agilite Software. All rights reserved.
//  Modified by Alasdair Allan on 07/04/2010.
//  Modifications Copyright 2010 Babilim Light Industries. All rights reserved.
//

#import "ARMarker.h"
#import "ARCoordinate.h"

#define BOX_WIDTH 150
#define BOX_HEIGHT 100

@implementation ARMarker

- (id)initForCoordinate:(ARCoordinate *)coordinate {
    	
	CGRect theFrame = CGRectMake(0, 0, BOX_WIDTH, BOX_HEIGHT);
	
	//NSLog( @"ARMarker:initForCoordinate: coordinate = %@", coordinate );
	
	if (self = [super initWithFrame:theFrame]) {
	
		UILabel *titleLabel	= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BOX_WIDTH, 20.0)];
		
		titleLabel.backgroundColor = [UIColor colorWithWhite:.3 alpha:.8];
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.textAlignment = UITextAlignmentCenter;
		titleLabel.text = coordinate.coordinateTitle;
		[titleLabel sizeToFit];
		[titleLabel setFrame: CGRectMake(BOX_WIDTH / 2.0 - titleLabel.bounds.size.width / 2.0 - 4.0, 0, titleLabel.bounds.size.width + 8.0, titleLabel.bounds.size.height + 8.0)];
		
		UIImageView *pointView	= [[UIImageView alloc] initWithFrame:CGRectZero];
		pointView.image = [UIImage imageNamed:@"point.png"];
		pointView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 - pointView.image.size.width / 2.0), (int)(BOX_HEIGHT / 2.0 - pointView.image.size.height / 2.0), pointView.image.size.width, pointView.image.size.height);
		
		UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeInfoLight];
		buttonView.frame = CGRectMake((int)(BOX_WIDTH / 2.0 + 20.0 - buttonView.bounds.size.width / 2.0), 
										   (int)(BOX_HEIGHT / 2.0 - buttonView.bounds.size.height/2.0), 
									       buttonView.bounds.size.width, 
									     buttonView.bounds.size.height );
		[buttonView addTarget:self action:@selector(infoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:titleLabel];
		[self addSubview:pointView];
		[self addSubview:buttonView];
		[self setBackgroundColor:[UIColor clearColor]];
		[titleLabel release];
		[pointView release];
		//NSLog( @"ARMarker:initForCoordinate: title = %@", coordinate.coordinateTitle );
		//NSLog( @"ARMarker:initForCoordinate: theFrame.size.width = %.3f, height = %.3f", theFrame.size.width, theFrame.size.height);
		//NSLog( @"ARMarker:initForCoordinate: titleLabel.frame.size.width = %.3f, height = %.3f", titleLabel.frame.size.width, titleLabel.frame.size.height);	
		//NSLog( @"ARMarker:initForCoordinate: pointView.frame.width = %.3f, height = %.3f", pointView.frame.size.width, pointView.frame.size.height);	
	}
	

    return self;
}

-(void)infoButtonPushed:(id)notification {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Button Pushed" message:@"Pushed the button." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    [alert show];  
    [alert release];  
	
	
}


- (void)dealloc {
    [super dealloc];
}


@end
