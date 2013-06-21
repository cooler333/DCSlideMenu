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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"WILL SHOW: %@", viewController.navigationItem.title);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"DID SHOW: %@", viewController.navigationItem.title);
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger currentIndex = [self currentIndex:indexPath];
    NSLog(@"didDeselectRowAtIndexPath currentIndex: %i", currentIndex);
    [_viewControllersArray replaceObjectAtIndex:currentIndex withObject:[containerController viewControllers]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"DCLOG SECTION: %i, ROW: %i", indexPath.section, indexPath.row);
    
    if (currentIndexPath != indexPath) {
        //Back up current stack
        NSUInteger row = [[_viewControllersArray objectAtIndex:[self currentIndex:indexPath]] count];
        if (!row) {
            [self initialViewControllers:indexPath];
        }
        NSArray *currentViewControllersArray = [_viewControllersArray objectAtIndex:[self currentIndex:indexPath]];
        [containerController setViewControllers:currentViewControllersArray];
        
        currentIndexPath = indexPath;
    }
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toggleMenu:)];
    [[[[containerController viewControllers] objectAtIndex:0] navigationItem] setLeftBarButtonItem:menuButton];
    [self closeMenu];
}

- (NSUInteger)currentIndex:(NSIndexPath *)indexPath {
    NSLog(@"INDEXPATH: %@", indexPath);
    NSUInteger currentIndex = 0;
    for(NSInteger i = 0 ; i <= indexPath.section-1 ; i++) {
       NSUInteger numberOfRowInSection = [menuController.tableView numberOfRowsInSection:i];
        currentIndex = currentIndex + numberOfRowInSection;;
    }
    currentIndex = currentIndex + indexPath.row;
    NSLog(@"currentIndex: %i", currentIndex);

    return currentIndex;
}

- (void)initialViewControllers:(NSIndexPath *)indexPath {
    
    UIViewController *viewController;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
                    break;
                }
                    
                case 1: {
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
                    break;
                }
                    
                case 2: {
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"third"];
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
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
                    break;
                }
                    
                case 1: {
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
                    break;
                }
                    
                case 2: {
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"third"];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    [[_viewControllersArray objectAtIndex:[self currentIndex:indexPath]] addObject:viewController];
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
        [frontView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3f]];
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
        [frontView setBackgroundColor:[UIColor clearColor]];
        
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
        
        NSUInteger rowsCount = 0;
        NSUInteger numberOfSections = [menuController.tableView numberOfSections];
        for(NSUInteger i = 0 ; i <= numberOfSections-1 ; i++) {
            NSUInteger numberOfRowsInSection = [menuController.tableView numberOfRowsInSection:i];
            rowsCount = rowsCount + numberOfRowsInSection;
            NSLog(@"COUNT: %i", rowsCount);
        }
        _viewControllersArray = [[NSMutableArray alloc] initWithCapacity:rowsCount];
        for(NSUInteger i = 0 ; i <= numberOfSections-1 ; i++) {
            NSUInteger numberOfRowInSection = [menuController.tableView numberOfRowsInSection:i];
            for(NSUInteger j = 0 ; j <= numberOfRowInSection-1 ; j++) {
                 NSMutableArray *array = [NSMutableArray array];
                  [_viewControllersArray addObject:array];
            }
        }
        
        NSLog(@"viewControllersArray count: %i \n %@", _viewControllersArray.count, _viewControllersArray);
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
