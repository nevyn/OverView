//
//  OVMovieDetailVC.m
//  OverView
//
//  Created by Joachim Bengtsson on 2010-08-11.
//  Copyright 2010 Third Cog Software. All rights reserved.
//

#import "OVMovieDetailVC.h"

@interface OVMovieDetailVC ()
@property(retain) MPMoviePlayerController *moviePlayer;
@end

static OVMovieDetailVC *singleton;

@implementation OVMovieDetailVC
@synthesize moviePlayer;

+(id)sharedDetailVC;
{
	return singleton;
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  singleton = self;
}

- (void)showMovieAtURL:(NSURL*)url;
{
  self.moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:url] autorelease];
  [moviePlayerContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  moviePlayer.view.frame = CGRectMake(0, 0, moviePlayerContainer.frame.size.width, moviePlayerContainer.frame.size.height);
  moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
  [moviePlayerContainer addSubview:moviePlayer.view];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Overriden to allow any orientation.
  return YES;
}


- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [super dealloc];
}


@end
