//
//  FirstViewController.m
//  Indogative
//
//  Created by Chris Fei on 9/2/14.
//  Copyright (c) 2014 Indogative. All rights reserved.
//

#import "FirstViewController.h"
#import "Indicative.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Indicative record:@"iOS - Viewed Page 1"];
    [Indicative record:@"iOS - Page View" withProperties:@{@"page": @(1)}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
