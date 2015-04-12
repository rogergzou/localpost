//
//  ViewController.m
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou and Charles Zhang. All rights reserved.
//

//current issue: Core Data syncing over web (ideally via Parse, though that 1000 object limit is annoying...). Want to have easiest, most lightweight framework. Have considered NSIncrementalStore, Dropbox Datastore, among others. Ultimately Parse's object API is easiest and seems like it would be globally accessible across all copies of the app. Going to completely synchronize them such that practically one-to-one.
//http://stackoverflow.com/questions/5035132/how-to-sync-iphone-core-data-with-web-server-and-then-push-to-other-devices?rq=1
//http://www.raywenderlich.com/17927/how-to-synchronize-core-data-with-a-web-service-part-2

#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "City.h"
#import "Post.h"
#import "AppDelegate.h"
@import AddressBookUI;

@interface ViewController () <CLLocationManagerDelegate>


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController; //fuck it
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *expireDatePicker;
@property (nonatomic, strong) City *currCity;
@property (nonatomic, strong) UIToolbar *blurToolbar;

@end

@implementation ViewController

- (IBAction)unhideCover:(id)sender {
    if (self.coverView.hidden == true) {
        self.coverView.hidden = false;
        self.expireDatePicker.date = [NSDate date];
    }
    else {
        self.coverView.hidden = true;
    }
}

- (IBAction)addEvent:(id)sender {
    //add to core data thing
    Post *currpost = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    if (self.messageTextField.text.length <= 40) {
        currpost.message = self.messageTextField.text;
        // ASSUMES IT'S 24 HOUR DEPENDENT ON THE SLIDER/DISPLAY. 1.0 to 24 hours
        currpost.expireTime = [NSDate dateWithTimeIntervalSinceNow:self.slider.value * 360]; //60 * 60 = 360. slider is 1-24
    
    
        currpost.latitude = [NSDecimalNumber decimalNumberWithDecimal: [@(mapview.userLocation.location.coordinate.latitude) decimalValue]];
        currpost.longitude = [NSDecimalNumber decimalNumberWithDecimal:[@(mapview.userLocation.location.coordinate.longitude)decimalValue]];
        currpost.city = self.currCity;
        [self.currCity addPostsObject:currpost];
        NSError *error;
        if (![self.managedObjectContext save:&error])
        NSLog(@"fail sav, %@", [error localizedDescription]);
        //put down a pin
        MKPointAnnotation *annot = [[MKPointAnnotation alloc]init];
        [annot setCoordinate:CLLocationCoordinate2DMake(mapview.userLocation.location.coordinate.latitude, mapview.userLocation.location.coordinate.longitude)];
        [annot setTitle:self.messageTextField.text];
        [mapview addAnnotation:annot];

        //hide
        self.coverView.hidden = true;
        [self.blurToolbar removeFromSuperview];
        self.messageTextField.text = @"";
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Failed to Post"
                                                                       message:@"Message needs to be 40 characters or less."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        self.messageTextField.text = @"";
        
    }
}

- (IBAction)onSlide:(id)sender {
    self.sliderLabel.text = [NSString stringWithFormat:@"Display message for %0.1f hours", self.slider.value];
}


@synthesize mapview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //test Parse code
    //PFObject *testobj = [PFObject objectWithClassName:@"TestObject"];
    //testobj[@"foo"] = @"bar";
    //[testobj saveInBackground];
    
    
    //test, my code for core data
    //NSManagedObjectContext *context = self.managedObjectContext;

    //default start as hidden
    self.coverView.hidden = true;
    
    // default slider
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 24;
    
    
        //charles' mapview code
    mapview.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // TODO: Add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    mapview.showsUserLocation = YES;
    
    [[self locationManager] startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    //self.fetchedResultsController = nil;
    [super viewDidDisappear:animated];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
        return _managedObjectContext;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    return _managedObjectContext;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200);
    [self.mapview setRegion:region animated: NO];
    /*ß
    [[self labelLatitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.latitude]];
    [[self labelLongitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.longitude]];
    [[self labelAltitude] setText:[NSString stringWithFormat:@"%.2f feet", location.altitude]];
    */
    
    //update current city and get local posts
    if (!self.currCity) {
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error)
                NSLog(@"reverse geolocate error, %@", [error localizedDescription]);
            else {
                CLPlacemark *placemark = [placemarks lastObject];
                //use locality concat w/ zipcode
                //get city and display posts here
                NSString *cityID;
                if (placemark.locality)
                    if (placemark.postalCode)
                        cityID = [placemark.locality stringByAppendingString:placemark.postalCode];
                    else
                        cityID = placemark.locality;
                else if (placemark.postalCode)
                    cityID = placemark.postalCode;
                else
                    return; //can't update city, can't post anything. sorry.
                
                //get stuff
                NSFetchRequest *fetchreq = [[NSFetchRequest alloc]init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
                [fetchreq setEntity:entity]; //prob
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@",
                                          cityID];
                [fetchreq setPredicate:predicate];
                
                NSError *error;
                NSArray *cities = [self.managedObjectContext executeFetchRequest:fetchreq error:&error];
                if (error)
                    NSLog(@"%@", [error localizedDescription]);
                if ([cities count] == 0) {
                    //no posts for that city
                    //create a City and insert into context for later, then set as currentCity.
                    City *c = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.managedObjectContext];
                    c.name = cityID;
                    c.posts = [[NSSet alloc]init]; //empty set
                    if(![self.managedObjectContext save:&error])
                        NSLog(@"err inserting city %@, %@", cityID, [error localizedDescription]);
                    else
                        self.currCity = c;
                    return;
                } else if ([cities count] > 3) {
                    NSLog(@"warningsssss this really shouldn't happen!");
                }
                //query should be unique, so just get this. if not unique...uh oh.
                self.currCity = [cities lastObject];
                for (Post *poster in self.currCity.posts) {
                    //add points to the map
                    MKPointAnnotation *annot = [[MKPointAnnotation alloc]init];
                    [annot setCoordinate:CLLocationCoordinate2DMake([poster.latitude doubleValue], [poster.longitude doubleValue])];
                    [annot setTitle:poster.message];
                    [mapview addAnnotation:annot];
                }
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"fail save, %@", [error localizedDescription]);
                }
            }
        }];
    }
}

@end
