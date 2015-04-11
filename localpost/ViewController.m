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

@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController; //fuck it

@end

@implementation ViewController

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




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self doNothing];
    self.Label.text = @"pie";
    
    
    //test
    //NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:self.managedObjectContext];
    [fetchreq setEntity:entity]; //prob
    NSError *error;
    NSArray *cities = [self.managedObjectContext executeFetchRequest:fetchreq error:&error];
    if (error)
        NSLog(@"%@", [error localizedDescription]);
    NSLog(@"ctys: %@", cities);
    City *boston = cities[0]; //trust for now
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    //self.fetchedResultsController = nil;
    [super viewDidDisappear:animated];
}

- (void)doNothing {
    //do nothing
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext)
        return _managedObjectContext;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    return _managedObjectContext;
}
/*
- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext)
        _managedObjectContext = [[[UIApplication sharedApplication]delegate]managedObjectContext]; //[[NSManagedObjectContext alloc]init];
    return _managedObjectContext;
}
*/
@end
