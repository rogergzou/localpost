//
//  MyCustomAnnotation.h
//  localpost
//
//  Created by Charles Zhang on 4/12/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/Corelocation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject <MKAnnotation> {
    
    
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;


@end
