//
//  ViewController.h
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou and Charles Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController {
    
    MKMapView *mapview;

}
@property (weak, nonatomic) IBOutlet UIVisualEffectView *coverView;

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIViewController *)control;

@property (weak, nonatomic) IBOutlet UISearchBar *filterSearch;

@property (nonatomic, retain) IBOutlet MKMapView *mapview;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelLatitude;

@property (weak, nonatomic) IBOutlet UILabel *labelLongitude;

@property (weak, nonatomic) IBOutlet UILabel *labelAltitude;


@end

