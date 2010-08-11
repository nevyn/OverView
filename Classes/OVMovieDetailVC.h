//
//  OVMovieDetailVC.h
//  OverView
//
//  Created by Joachim Bengtsson on 2010-08-11.
//  Copyright 2010 Third Cog Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface OVMovieDetailVC : UIViewController {
	IBOutlet UIView *moviePlayerContainer;
  MPMoviePlayerController *moviePlayer;
}

@end
