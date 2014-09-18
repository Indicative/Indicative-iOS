//
//  SecondViewController.m
//  Indogative
//
//  Created by Chris Fei on 9/2/14.
//  Copyright (c) 2014 Indogative. All rights reserved.
//

#import "SecondViewController.h"
#import "Indicative.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [Indicative record:@"iOS - Viewed Page 2"];
    [Indicative record:@"iOS - Page View" withProperties:@{@"page": @(2)}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
