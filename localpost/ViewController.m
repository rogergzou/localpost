//
//  ViewController.m
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou and Charles Zhang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "City.h"
#import "Post.h"
#import "AppDelegate.h"

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
    //self.coverView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.35]; //.6
    if (self.coverView.hidden == true) {
        //UIView *myView = self.coverView;
        //myView.backgroundColor = [UIColor clearColor];
        //UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:myView.frame];
        //bgToolbar.barStyle = UIBarStyleDefault;
        //[myView.superview insertSubview:bgToolbar belowSubview:myView];
        //self.blurToolbar = bgToolbar;

        
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
    currpost.message = self.messageTextField.text;
    NSLog(@"date exp %@", self.expireDatePicker.date);
    currpost.expireTime = self.expireDatePicker.date;
    currpost.latitude = [NSDecimalNumber decimalNumberWithDecimal: [@(mapview.userLocation.location.coordinate.latitude) decimalValue]];
    currpost.longitude = [NSDecimalNumber decimalNumberWithDecimal:[@(mapview.userLocation.location.coordinate.longitude)decimalValue]];
    currpost.city = self.currCity;
    [self.currCity addPostsObject:currpost];
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"fail sav, %@", [error localizedDescription]);
    //test if fetched?
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *citya in fetchedObjects) {
        NSLog(@"Name: %@", [citya valueForKey:@"name"]);
        NSSet *posts = [citya valueForKey:@"posts"];
        //        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
        for (NSManagedObject *posta in posts) {
            NSLog(@"Message: %@", [posta valueForKey:@"message"]);
        }
    }
    self.coverView.hidden = true;
    [self.blurToolbar removeFromSuperview];
    self.messageTextField.text = @"";
}

/* //fuck it
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"expireDate" ascending:NO]
    ;
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    return nil; //
}
 */

- (IBAction)onSlide:(id)sender {
    self.sliderLabel.text = [NSString stringWithFormat:@"Display message for %0.1f hours", self.slider.value];
}


@synthesize mapview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //test, my code for core data
    //NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
    [fetchreq setEntity:entity]; //prob
    NSError *error;
    NSArray *cities = [self.managedObjectContext executeFetchRequest:fetchreq error:&error];
    if (error)
        NSLog(@"%@", [error localizedDescription]);
    NSLog(@"ctys: %@", cities);
    
    
    ///HARDCODED
    
    City *boston = cities[0]; //trust for now
    self.currCity = boston;
    
    ///HARDCODED
    
    
    //[self.managedObjectContext deleteObject:cities[1]];
    //[self.managedObjectContext deleteObject:cities[2]];
    //int i = 0;
    NSLog(@"psts: %@", boston.posts);
    for (Post *poster in boston.posts) {
        //NSLog(@"%@", poster);
        poster.message = [poster.message stringByAppendingString:@"6"];
        NSLog(@"%@, mess: %@", poster, poster.message);
        //if (i > 1) {
            //[self.managedObjectContext deleteObject:poster];
        //}
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"fail save, %@", [error localizedDescription]);
    }

    //default start as hidden
    self.coverView.hidden = true;
    
    // default slider
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 24;
    
    
        //charles' mapview code
    mapview.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    // TODO: Add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    mapview.showsUserLocation = YES;
    
    [[self locationManager] startUpdatingLocation];
    
    CLLocation * myLocation = self.location;
    
    //self.mapview.region = { {myLocation.coordinate.latitude, myLocation.coordinate.longitude}
    
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    MKCoordinateRegion adjustedRegion = [self.mapview regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200)];
    [self.mapview setRegion:adjustedRegion animated:YES];

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
    
    [[self labelLatitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.latitude]];
    [[self labelLongitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.longitude]];
    [[self labelAltitude] setText:[NSString stringWithFormat:@"%.2f feet", location.altitude]];
}

@end
