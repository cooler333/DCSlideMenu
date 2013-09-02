//
//  DCDetailViewController.h
//  testFeatures
//
//  Created by cooler on 15.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DCMenuViewController.h"


@interface DCContainerViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
    __weak IBOutlet UIView *menuContainerView;
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *frontView;
    __weak IBOutlet NSLayoutConstraint *frontViewConstraint;
    __weak IBOutlet NSLayoutConstraint *containerConstraint;
    
    CGFloat firstX;
	CGFloat firstY;
    
}

@property UINavigationController *containerController;
@property DCMenuViewController *menuController;

//@property NSIndexPath *currentIndexPath;


- (IBAction)moving:(UIPanGestureRecognizer *)sender;
- (IBAction)tapOnFrontView:(UITapGestureRecognizer *)sender;
//- (void)selectMenuSegmentAtIndexPath:(NSIndexPath *)indexPath;
- (void)toggleMenu;
- (void)closeMenu;

@end
