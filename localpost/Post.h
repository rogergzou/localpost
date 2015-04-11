//
//  Post.h
//  localpost
//
//  Created by Roger on 4/11/15.
//  Copyright (c) 2015 Roger Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSDate * expireTime;
@property (nonatomic, retain) NSDecimalNumber * longitude;
@property (nonatomic, retain) NSDecimalNumber * latitude;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) City *city;

@end
