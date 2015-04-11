//
//  ViewController.h
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController {
    
    MKMapView *mapview;
    
}
@property (weak, nonatomic) IBOutlet UIView *coverView;


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@property (nonatomic, retain) IBOutlet MKMapView *mapview;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UILabel *labelLatitude;

@property (weak, nonatomic) IBOutlet UILabel *labelLongitude;

@property (weak, nonatomic) IBOutlet UILabel *labelAltitude;


@end

