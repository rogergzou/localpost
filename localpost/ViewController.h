//
//  ViewController.h
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController {
    
    MKMapView *mapview;
    
}
@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (nonatomic, retain) IBOutlet MKMapView *mapview;




@end

