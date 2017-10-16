//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"
#import <MobileCoreServices/UTCoreTypes.h>


#define kCameraRollZH @"所有照片"

@interface ELCAlbumPickerController ()

@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
    // Loading...
	[self.navigationItem setTitle:NSLocalizedString(@"正在加载", nil)];

    // UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;

    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
        @autoreleasepool {
        
        // Group enumerator Block
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                if (group == nil) {
                    return;
                }
                
                // added fix for camera albums order
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                
                // Camera Roll  @"Camera Roll"   kCameraRollZH
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"Camera Roll"] && nType == ALAssetsGroupSavedPhotos) {
                    [self.assetGroups insertObject:group atIndex:0];
                }
                else {
                    [self.assetGroups addObject:group];
                }

                // Reload albums
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            };
            
            // Group Enumerator Failure Block
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
              
                // This app does not have access to your photos or videos. You can enable access in Privacy Settings.
                if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                    NSString *errorMessage = NSLocalizedString(@"这个程序没有访问你的照片或视频的权限。你可以隐私中设置。", nil);
                    // Access Denied     Ok
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"拒绝", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"好的", nil) otherButtonTitles:nil] show];
                  
                } else {
                    // Album Error
                    NSString *errorMessage = [NSString stringWithFormat:@"相簿错误: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]];
                    // Error   Ok
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"出错了", nil) message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了", nil) otherButtonTitles:nil] show];
                }

                [self.navigationItem setTitle:nil];
                NSLog(@"A problem occured %@", [error description]);	                                 
            };	
                    
            // Enumerate Albums
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
        
        }
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:ALAssetsLibraryChangedNotification object:nil];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
}

- (void)reloadTableView
{
	[self.tableView reloadData];
    // Select an Album
	[self.navigationItem setTitle:NSLocalizedString(@"照片", nil)];
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (BOOL)shouldDeselectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldDeselectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

- (ALAssetsFilter *)assetFilter
{
    if([self.mediaTypes containsObject:(NSString *)kUTTypeImage] && [self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
    {
        return [ALAssetsFilter allAssets];
    }
    else if([self.mediaTypes containsObject:(NSString *)kUTTypeMovie])
    {
        return [ALAssetsFilter allVideos];
    }
    else
    {
        return [ALAssetsFilter allPhotos];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[self assetFilter]];
    NSInteger gCount = [g numberOfAssets];
    
    // [g valueForProperty:ALAssetsGroupPropertyName]
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)", kCameraRollZH, (long)gCount];
    UIImage* image = [UIImage imageWithCGImage:[g posterImage]];
    image = [self resize:image to:CGSizeMake(78, 78)];
    [cell.imageView setImage:image];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

// Resize a UIImage. From http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
- (UIImage *)resize:(UIImage *)image to:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
	picker.parent = self;

    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[self assetFilter]];
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 95;
}

@end

