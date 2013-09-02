//
//  DCTableViewController.h
//  testFeatures
//
//  Created by cooler on 16.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DCMenuViewController : UIViewController <UIActionSheetDelegate> {
    
    NSMutableArray *viewControllersArray;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSIndexPath *currentIndexPath;

@property id delegate;

- (IBAction)logout:(id)sender;
- (void)selectMenuSegmentAtIndexPath:(NSIndexPath *)indexPath;

@end