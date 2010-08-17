//
//  OVFileListVC.h
//  OverView
//
//  Created by Joachim Bengtsson on 2010-08-15.
//  Copyright 2010 Third Cog Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OVFileListVC : UITableViewController {
	NSString *_folderPath;
	NSArray *_contents;
}
-(void)useFolderPath:(NSString*)folderPath;
@end
