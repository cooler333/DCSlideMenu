//
//  DCDetailViewController.m
//  testFeatures
//
//  Created by cooler on 15.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import "DCContainerViewController.h"


static CGFloat rightMenuEdge = 270.0f;
static CGFloat centerEdge = 230.0f;


@implementation DCContainerViewController

#pragma mark - Menu Gestures

- (void)viewDidLoad {
    [_menuController selectMenuSegmentAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
}

- (BOOL)gestureRecognizerShouldBegin:(id)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translatedPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view];
        NSLog(@"gestureRecognizerShouldBegin %.2f", translatedPoint.x);
        if (containerView.center.x <= 160 && translatedPoint.x <=0) {
            return NO;
        } else return YES;
    } else return YES;
    
}

- (IBAction)moving:(UIPanGestureRecognizer *)sender {
    
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"BEGAN");
            [frontView setUserInteractionEnabled:YES];
            [_containerController.view setUserInteractionEnabled:NO];
            
            firstX = [containerView center].x;
            firstY = [containerView center].y;
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
            
            if (translatedPoint.x < 160.0f) {
                translatedPoint.x = 160.0f;
            }
            
            [self.view layoutIfNeeded];
            [containerConstraint setConstant:translatedPoint.x-160.0f];
            [frontViewConstraint setConstant:translatedPoint.x-160.0f];
            [UIView animateWithDuration:0.0f animations:^{
                [self.view layoutIfNeeded];
                [_containerController.view layoutIfNeeded];
                [_menuController.view layoutIfNeeded];
            }];
            break;
        }
            
        case UIGestureRecognizerStateEnded:  {
            NSLog(@"END");
            [frontView setUserInteractionEnabled:NO];
            [_containerController.view setUserInteractionEnabled:YES];
            
            CGFloat xPoints = 320.0f;
            CGFloat velocity = [sender velocityInView:self.view].x;
            NSLog(@"velocity: %.2f",velocity);
            NSTimeInterval duration = xPoints / ABS(velocity);
            NSLog(@"duration %.2f", duration);
            if (duration > 0.5f) {
                duration = 0.5f;
            } else if (duration < 0.2f) {
                duration = 0.2f;
            } else {
                NSLog(@"All Right");
            }
            
            CGFloat finalX = translatedPoint.x + velocity;
            
            if (finalX <= centerEdge) {
                [containerConstraint setConstant:0];
                [frontViewConstraint setConstant:0];
            } else if (finalX > centerEdge) {
                [containerConstraint setConstant:rightMenuEdge];
                [frontViewConstraint setConstant:rightMenuEdge];
                [containerView endEditing:YES];
            }
            
            [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                if (finalX <= centerEdge) {
                    [_menuController.tableView deselectRowAtIndexPath:_menuController.currentIndexPath animated:YES];
                } else if (finalX > centerEdge) {
                    [_menuController.tableView selectRowAtIndexPath:_menuController.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }
                [self.view layoutIfNeeded];
                [_containerController.view layoutIfNeeded];
                [_menuController.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (finalX <= centerEdge) {
                    [frontView setUserInteractionEnabled:NO];
                } else if (finalX > centerEdge) {
                    [frontView setUserInteractionEnabled:YES];
                }
                [self.view layoutIfNeeded];
                [_containerController.view layoutIfNeeded];
                [_menuController.view layoutIfNeeded];
            }];
            break;
        }
            
        default:
            break;
    }
    
}

- (IBAction)tapOnFrontView:(UITapGestureRecognizer *)sender {
    [self closeMenu];
}

- (void)closeMenu {
    [containerConstraint setConstant:0.0f];
    [frontViewConstraint setConstant:0.0f];
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_menuController.tableView deselectRowAtIndexPath:_menuController.currentIndexPath animated:YES];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [frontView setUserInteractionEnabled:NO];
        [_menuController.tableView reloadData];
    }];
}

- (void)openMenu {
    [containerView endEditing:YES];
    
    [containerConstraint setConstant:rightMenuEdge];
    [frontViewConstraint setConstant:rightMenuEdge];
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_menuController.tableView selectRowAtIndexPath:_menuController.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [frontView setUserInteractionEnabled:YES];
//        [_menuController.tableView reloadData];
    }];
}

- (void)toggleMenu {
    if (containerView.center.x <= centerEdge) {
        [self openMenu];
    } else if (containerView.center.x > centerEdge) {
        [self closeMenu];
    }
}

#pragma mark - Private Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"content"]) {
        self.containerController = segue.destinationViewController;
        [self.containerController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"menu"]) {
        self.menuController = segue.destinationViewController;
        [self.menuController setDelegate:self];
    }
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //LOGOUT ACTION
    if (buttonIndex == 0) {
        //Log out
    }
    else
    {
        //logout cancelled
        //        [self selectMenuSegmentAtIndexPath:currentIndexPath];
    }
}

@end