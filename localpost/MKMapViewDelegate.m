//
//  MKMapViewDelegate.m
//  localpost
//
//  Created by Charles Zhang on 4/12/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import "MKMapViewDelegate.h"

@implementation MKMapViewDelegate

- (void)mapView:(MKMapView *) mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"The annotation tapped is: %@", view.annotation.title);
}

@end