//
//  OverViewAppDelegate.h
//  OverView
//
//  Created by Joachim Bengtsson on 2010-08-11.
//  Copyright Third Cog Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OVRootVC.h"

@interface OverViewAppDelegate : NSObject <UIApplicationDelegate> {
  IBOutlet UIWindow *window;
  IBOutlet OVRootVC *viewController;
}
@end

