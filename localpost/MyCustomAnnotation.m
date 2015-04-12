//
//  MyCustomAnnotation.m
//  localpost
//
//  Created by Charles Zhang on 4/12/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
