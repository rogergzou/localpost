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
    
    mapview.showsUserLocation = YES;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doNothing {
    //do nothing
}



@end
