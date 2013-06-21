//
//  DCDetailViewController.m
//  testFeatures
//
//  Created by cooler on 15.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import "DCDetailViewController.h"


static CGFloat rightEdge = 440.0f; // 440 - 160 = 280
static CGFloat centerEdge = 300.0f;


@implementation DCDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:menuController.tableView didSelectRowAtIndexPath:indexPath];
    [menuController.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    NSLog(@"DETAIL VIEW LOAD");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"DCLOG SECTION: %i _ ROW: %i", indexPath.section, indexPath.row);
    
    
    NSMutableArray *viewControllersArray;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                    
                case 1: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                    
                case 2: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"third"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default: {
            switch (indexPath.row) {
                case 0: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                    
                case 1: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                    
                case 2: {
                    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"third"];
                    viewControllersArray = [NSMutableArray arrayWithArray:@[viewController]];
                    [containerController setViewControllers:viewControllersArray];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMenu:)];
    [[[containerController topViewController] navigationItem] setLeftBarButtonItem:menuButton];
    [self closeMenu];
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
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        NSLog(@"BEGAN");
        [frontView setUserInteractionEnabled:YES];
        firstX = [containerView center].x;
        firstY = [containerView center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
    
    if (translatedPoint.x < 160.0f) {
        translatedPoint.x = 160.0f;
    }
        
    [containerView setCenter:translatedPoint];
    [frontView setCenter:translatedPoint];
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [frontView setUserInteractionEnabled:NO];
        
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
        CGFloat finalY = translatedPoint.y;
        
        if (finalX <= centerEdge) {
            finalX = 160.0f;
        } else if (finalX > centerEdge) {
            finalX = rightEdge;
        }
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGFloat relation = finalX/rightEdge;
            NSLog(@"relation; %.1f",relation);
            [containerView setCenter:CGPointMake(finalX, finalY)];
            [frontView setCenter:CGPointMake(finalX, finalY)];
        } completion:^(BOOL finished) {
            if (finalX <= centerEdge) {
                [frontView setUserInteractionEnabled:NO];
            } else if (finalX > centerEdge) {
                [frontView setUserInteractionEnabled:YES];
            }
        }];
    }
}

- (IBAction)tapOnFrontView:(UITapGestureRecognizer *)sender {
    [self closeMenu];
}

- (void)closeMenu {
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [containerView setCenter:CGPointMake(160, self.view.frame.size.height/2)];
        [frontView setCenter:CGPointMake(160, self.view.frame.size.height/2)];
    } completion:^(BOOL finished) {
        [frontView setUserInteractionEnabled:NO];
    }];
}

- (void)openMenu {
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [containerView setCenter:CGPointMake(rightEdge, self.view.frame.size.height/2)];
        [frontView setCenter:CGPointMake(rightEdge, self.view.frame.size.height/2)];
    } completion:^(BOOL finished) {
        [frontView setUserInteractionEnabled:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@",segue.identifier);

    if ([segue.identifier isEqualToString:@"content"]) {
        containerController = segue.destinationViewController;
        [containerController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"menu"]) {
        menuController = segue.destinationViewController;
        [menuController.tableView setDelegate:self];
    }
}

- (void)toggleMenu:(id)sender {
    if (containerView.center.x <= centerEdge) {
        [self openMenu];
    } else if (containerView.center.x > centerEdge) {
        [self closeMenu];
    }
}
@end
