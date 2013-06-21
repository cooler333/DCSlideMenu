//
//  DCNavigationController.m
//  testFeatures
//
//  Created by cooler on 15.06.13.
//  Copyright (c) 2013 Dmitry Utmanov. All rights reserved.
//


#import "DCNavigationController.h"
#import "DCDetailViewController.h"

@interface DCNavigationController ()

@end

@implementation DCNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)toggleMenu:(id)sender {
    DCDetailViewController *vc = self.delegate;
    [vc toggleMenu:sender];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%@", viewController.navigationItem.title);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
