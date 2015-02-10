//
//  ViewController.m
//  GeolocationPractice
//
//  Created by Shannon Beck on 2/7/15.
//  Copyright (c) 2015 Shannon Beck. All rights reserved.
//

#import "RootViewController.h"
#import "SortedUser.h"
#import "MusicAppUser.h"
#import "ChatViewController.h"
#import "Message.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface RootViewController () <CLLocationManagerDelegate>

@property NSMutableArray *usersArray;
@property CLLocationManager *myLocationManager;
@property CLLocation *currentUserLocation;
@property NSMutableArray *distances;
@property NSMutableArray *sortedUsersArray;
@property NSArray *finalSortedUsersArray;
@property MusicAppUser *currentUser;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;
@property (strong, nonatomic) IBOutlet UILabel *fifthLabel;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.distances = [[NSMutableArray alloc]init];
    self.sortedUsersArray = [[NSMutableArray alloc]init];
    self.finalSortedUsersArray = [[NSArray alloc]init];

    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;

    self.usersArray = [[NSMutableArray alloc]init];

    self.currentUser = [MusicAppUser currentUser];

    if (self.currentUser)
    {
        NSLog(@"Current user: %@", [self.currentUser username]);
        PFQuery *query = [MusicAppUser query];
        [query whereKey:@"objectId" notEqualTo:[MusicAppUser currentUser].objectId];
        self.usersArray = [[query findObjects]mutableCopy];
        [self.myLocationManager startUpdatingLocation];
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (IBAction)refreshLocationButton:(id)sender
{
    [self.usersArray removeAllObjects];
    PFQuery *query = [MusicAppUser query];
    [query whereKey:@"objectId" notEqualTo:[MusicAppUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [self.usersArray addObjectsFromArray:objects];
        [self.myLocationManager startUpdatingLocation];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.myLocationManager stopUpdatingLocation];
    self.currentUserLocation = [locations lastObject];
    NSLog(@"%@", [NSString stringWithFormat:@"%f", self.currentUserLocation.coordinate.latitude]);
    NSLog(@"%@", [NSString stringWithFormat:@"%f", self.currentUserLocation.coordinate.longitude]);

    self.currentUser.latitude = self.currentUserLocation.coordinate.latitude;
    self.currentUser.longitude = self.currentUserLocation.coordinate.longitude;

    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
          [self findDistanceBetween];
    }];
}

- (void)findDistanceBetween
{
    [self.sortedUsersArray removeAllObjects];
    for (MusicAppUser *thisUser in self.usersArray)
    {
        CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:self.currentUserLocation.coordinate.latitude longitude:self.currentUserLocation.coordinate.longitude];
        CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:thisUser.latitude longitude:thisUser.longitude];
        CLLocationDistance dist = [userLoc distanceFromLocation:poiLoc];
        float milesDifference = dist / 1609.34;

        SortedUser *sortedUser = [[SortedUser alloc]init];
        sortedUser.user = thisUser;
        sortedUser.distanceFromCurrentUser = milesDifference;

        [self.sortedUsersArray addObject:sortedUser];
    }

    for (SortedUser *thisSortedUser in self.sortedUsersArray)
    {
        NSLog(@"%@", thisSortedUser.user.username);
    }

    [self sortTheArray];

    for (MusicAppUser *thisUser in self.sortedUsersArray)
    {
        NSLog(@"%@", thisUser.username);
    }

}

- (void)sortTheArray
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromCurrentUser" ascending:true];
    self.finalSortedUsersArray = [self.sortedUsersArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.sortedUsersArray removeAllObjects];
    for (SortedUser *thisSortedUser in self.finalSortedUsersArray)
    {
        [self.sortedUsersArray addObject:thisSortedUser.user];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chat"])
    {
        ChatViewController *chatVC = segue.destinationViewController;
        chatVC.currentUser = self.currentUser;
        chatVC.closestUsers = self.sortedUsersArray;
    }
}


@end
