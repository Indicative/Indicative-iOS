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
    [self printState:nil];
    [Indicative record:@"iOS - Viewed Page 1 (Objective C)"];
    [Indicative record:@"iOS - Page View" withProperties:@{@"page": @(1)}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)printState:(id)sender {
    NSLog(@"Indicative unique key: %@", [Indicative uniqueKey]);
    NSLog(@"Indicative anonymousId: %@", [Indicative anonymousId]);
}

-(IBAction)sendEvent:(id)sender {
    [Indicative record:@"Event 1" withProperties:@{
        @"myprop1": @"myval1"
    }];
}

-(IBAction)flushEvents:(id)sender {
    [Indicative flushEvents];
}

-(IBAction)sendAlias:(id)sender {
    [Indicative identifyUserWithAlias:@"my aliased user"];
}

-(IBAction)reset:(id)sender {
    [Indicative reset];
    NSLog(@"Indicative unique key: %@", [Indicative uniqueKey]);
    NSLog(@"Indicative anonymousId: %@", [Indicative anonymousId]);
}

-(IBAction)setUniqueKey:(id)sender {
    [Indicative identifyUser:@"Unique asdf"];
}

@end
