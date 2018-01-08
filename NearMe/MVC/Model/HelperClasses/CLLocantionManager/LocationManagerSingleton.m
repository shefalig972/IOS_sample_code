//
//  LocationManagerSingleton.m
//  NearMe
//
//  Created by Talentelgia on 10/07/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "LocationManagerSingleton.h"


@implementation LocationManagerSingleton
{
    GMSMarker *dyanamicMarker;
}
@synthesize locationManager;

- (id)init {
    self = [super init];

    if (self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        if (IS_OS_8_OR_LATER) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
        [self starUpdate];
//        [self.locationManager startUpdatingLocation]; //update user current location when user alloc the locaton manager.
    }
    return self;
}

+ (LocationManagerSingleton*)sharedSingleton {
    static LocationManagerSingleton* sharedSingleton;
   if (!sharedSingleton) {
        @synchronized(sharedSingleton){
            sharedSingleton = [LocationManagerSingleton new];
        }
   }else {
       [sharedSingleton starUpdate];
   }
    return sharedSingleton;
}

- (void)starUpdate {
    [locationManager startUpdatingLocation]; //update user current location when user alloc the locaton manager.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //handle your location updates here
    CLLocation* currentLocation = [locations firstObject];
    
    DELEGATE.currentPoints = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    NSLog(@"%f %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    GMSMarker *pointMarker = [GMSMarker markerWithPosition:DELEGATE.currentPoints];
    dyanamicMarker.map = nil;
    dyanamicMarker  = pointMarker;
    pointMarker.icon = [UIImage imageNamed:@"location.png"];
    pointMarker.map = DELEGATE.mapView_;
  //  [locationManager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"update old location.....");
   // /    CLLocation* currentLocation = [locations firstObject];
    if (oldLocation) {
        NSLog(@"not nil");
        newMarker.map = nil;
    }
        DELEGATE.currentPoints = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
        NSLog(@"%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        newMarker= [GMSMarker markerWithPosition:DELEGATE.currentPoints];
        newMarker.icon = [UIImage imageNamed:@"Milestone-Icon.png"];
        newMarker.map = DELEGATE.mapView_;
    oldMarker=newMarker;
       [locationManager stopUpdatingLocation];

    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //handle your heading updates here- I would suggest only handling the nth update, because they
    //come in fast and furious and it takes a lot of processing power to handle all of them
}

@end
