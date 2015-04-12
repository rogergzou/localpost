//
//  MKMapViewDelegate.h
//  localpost
//
//  Created by Charles Zhang on 4/12/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MKMapViewDelegate : UIViewController <MKMapViewDelegate>

- (void)mapView:(MKMapView *) mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control;

@end
