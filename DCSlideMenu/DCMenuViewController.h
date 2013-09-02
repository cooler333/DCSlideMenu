//
//  DCTableViewController.h
//  testFeatures
//
//  Created by cooler on 16.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DCMenuViewController : UITableViewController <UIActionSheetDelegate> {
    
    NSMutableArray *viewControllersArray;
    
}

@property NSIndexPath *currentIndexPath;
@property id customDelegate;

- (void)selectMenuSegmentAtIndexPath:(NSIndexPath *)indexPath;

@end