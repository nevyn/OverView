//
//  OVFileListVC.m
//  OverView
//
//  Created by Joachim Bengtsson on 2010-08-15.
//  Copyright 2010 Third Cog Software. All rights reserved.
//

#import "OVFileListVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "OVMovieDetailVC.h"

@interface OVFileListVC ()
@property(retain) NSArray *contents;
@end

static UIImage *OVThumbForFile(NSString *path)
{
	NSString *thumbPath = [[[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"thumbs"] stringByAppendingPathComponent:[path lastPathComponent]];
	if([[NSFileManager defaultManager] fileExistsAtPath:thumbPath])
		return [UIImage imageWithContentsOfFile:thumbPath];
	else {
		MPMoviePlayerController *moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:path]] autorelease];
		UIImage *thumb = [moviePlayer thumbnailImageAtTime:10.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
		[UIImageJPEGRepresentation(thumb, 0.8) writeToFile:thumbPath atomically:NO];
		return thumb;
	}
}


@implementation OVFileListVC
@synthesize contents = _contents;
+(NSString*)contentRoot;
{
	NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return docs;
}
-(void)refreshContent;
{
	self.contents = _folderPath?[[NSFileManager defaultManager] contentsOfDirectoryAtPath:_folderPath error:nil]:nil;
	[self.tableView reloadData];
}
-(void)useFolderPath:(NSString*)folderPath;
{
	[_folderPath release];
	
	if(!folderPath)
		_folderPath = nil;
	else if([folderPath hasPrefix:@"/"])
		_folderPath = [folderPath retain];
	else
		_folderPath = [[[OVFileListVC contentRoot] stringByAppendingPathComponent:folderPath] retain];
	
	[self refreshContent];
	self.title = [folderPath length]?[folderPath lastPathComponent]:[[NSProcessInfo processInfo] processName];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.backgroundColor = self.navigationController.navigationBar.backgroundColor;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_contents count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	NSString *path = [_folderPath stringByAppendingPathComponent:[_contents objectAtIndex:indexPath.row]];
	
	BOOL isDir = NO;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if(isDir) {
		cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if(!exists)
		cell.imageView.image = [UIImage imageNamed:@"Unknown.png"];
	else
		cell.imageView.image = OVThumbForFile(path);
		
	cell.textLabel.text = [[path lastPathComponent] stringByDeletingPathExtension];
	cell.backgroundColor = self.navigationController.navigationBar.backgroundColor;
	cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *path = [_folderPath stringByAppendingPathComponent:[_contents objectAtIndex:indexPath.row]];
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
		[self refreshContent];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *path = [_folderPath stringByAppendingPathComponent:[_contents objectAtIndex:indexPath.row]];
	
	BOOL isDir = NO;
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if(isDir) {
		OVFileListVC *subfolderVC = [[OVFileListVC new] autorelease];
		[subfolderVC useFolderPath:path];
		[self.navigationController pushViewController:subfolderVC animated:YES];
	} else {
		[[OVMovieDetailVC sharedDetailVC] showMovieAtURL:[NSURL fileURLWithPath:path]];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

