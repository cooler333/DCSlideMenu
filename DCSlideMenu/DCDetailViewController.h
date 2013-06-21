//
//  DCDetailViewController.h
//  testFeatures
//
//  Created by cooler on 15.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DCNavigationController.h"
#import "DCTableViewController.h"


@interface DCDetailViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UINavigationControllerDelegate> {
    
    __weak IBOutlet UIView *menuContainerView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *frontView;
    
    DCNavigationController *containerController;
    DCTableViewController *menuController;
    
    NSMutableArray *_viewControllersArray;
    NSIndexPath *currentIndexPath;
    
    CGFloat firstX;
	CGFloat firstY;
    
}

- (IBAction)moving:(UIPanGestureRecognizer *)sender;
- (IBAction)tapOnFrontView:(UITapGestureRecognizer *)sender;

- (void)toggleMenu:(id)sender;


@end
