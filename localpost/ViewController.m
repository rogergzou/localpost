//
//  ViewController.m
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou and Charles Zhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self doNothing];
    [self showLocation];
    MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
    //region.center.latitude =
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [mapview setRegion:region animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doNothing {
    //do nothing
}

- (void) showLocation {
    mapview.showsUserLocation = YES;
    
}

@end
