//
//  LocationManagerSingleton.h
//  NearMe
//
//  Created by Talentelgia on 10/07/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constant.h"
@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>
{
    NSArray *markerArray;
    GMSMarker *oldMarker;
    GMSMarker *newMarker;

}
@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationManagerSingleton*)sharedSingleton;

- (void)starUpdate;

@end
