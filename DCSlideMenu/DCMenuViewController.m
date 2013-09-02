//
//  DCTableViewController.m
//  testFeatures
//
//  Created by cooler on 16.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import "DCMenuViewController.h"
#import "DCContainerViewController.h"


@implementation DCMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger rowsCount = 0;
    NSUInteger numberOfSections = [self.tableView numberOfSections];
    for(NSUInteger i = 0 ; i <= numberOfSections-1 ; i++) {
        NSUInteger numberOfRowsInSection = [self.tableView numberOfRowsInSection:i];
        rowsCount = rowsCount + numberOfRowsInSection;
        NSLog(@"COUNT: %i", rowsCount);
    }
    viewControllersArray = [[NSMutableArray alloc] initWithCapacity:rowsCount];
    for(NSUInteger i = 0 ; i <= numberOfSections-1 ; i++) {
        NSUInteger numberOfRowInSection = [self.tableView numberOfRowsInSection:i];
        for(NSUInteger j = 0 ; j <= numberOfRowInSection-1 ; j++) {
            NSMutableArray *array = [NSMutableArray array];
            [viewControllersArray addObject:array];
        }
    }
    
    NSLog(@"viewControllersArray count: %i \n %@", viewControllersArray.count, viewControllersArray);
}

- (void)selectMenuSegmentAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (IBAction)logout:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil] showInView:self.view];
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
                default:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"third"];
                    break;
            }
            break;
        }
            
        default: {
            switch (indexPath.row) {
                default:
                    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
                    break;
            }
            break;
        }
    }
    [[viewControllersArray objectAtIndex:[self currentIndex:indexPath]] addObject:viewController];
}

- (NSUInteger)currentIndex:(NSIndexPath *)indexPath {
    NSLog(@"INDEXPATH: %@", indexPath);
    NSUInteger currentIndex = 0;
    for(NSInteger i = 0 ; i <= indexPath.section-1 ; i++) {
        NSUInteger numberOfRowInSection = [self.tableView numberOfRowsInSection:i];
        currentIndex = currentIndex + numberOfRowInSection;;
    }
    currentIndex = currentIndex + indexPath.row;
    NSLog(@"currentIndex: %i", currentIndex);
    
    return currentIndex;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DCContainerViewController *controller = self.customDelegate;
    NSUInteger currentIndex = [self currentIndex:indexPath];
    NSLog(@"didDeselectRowAtIndexPath currentIndex: %i", currentIndex);
    [viewControllersArray replaceObjectAtIndex:currentIndex withObject:[controller.containerController viewControllers]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"DCLOG SECTION: %i, ROW: %i", indexPath.section, indexPath.row);
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [[[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil] showInView:self.view];
    } else {
        if (_currentIndexPath != indexPath || indexPath == nil) {
            //Back up current stack
            NSUInteger count = [[viewControllersArray objectAtIndex:[self currentIndex:indexPath]] count];
            if (!count) {
                [self initialViewControllers:indexPath];
            }
            NSArray *currentViewControllersArray = [viewControllersArray objectAtIndex:[self currentIndex:indexPath]];
            DCContainerViewController *controller = self.customDelegate;
            [controller.containerController setViewControllers:currentViewControllersArray];
            
            self.currentIndexPath = indexPath;
        }
        DCContainerViewController *controller = self.customDelegate;
        [controller.view layoutIfNeeded];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu)];
        [[[[controller.containerController viewControllers] objectAtIndex:0] navigationItem] setLeftBarButtonItem:menuButton];
        [controller.view layoutIfNeeded];
        [self.customDelegate closeMenu];
    }
}

- (void)toggleMenu {
    [self.customDelegate toggleMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.0;
            break;
            
        default:
            return 44.0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    // Prepare Cell
    return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Log Out");
    }
    else
    {
        [self selectMenuSegmentAtIndexPath:_currentIndexPath];
    }
}
@end
