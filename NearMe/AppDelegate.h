//
//  AppDelegate.h
//  NearMe
//
//  Created by Talentelgia on 6/17/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Constant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (assign) CLLocationCoordinate2D currentPoints;

@property (nonatomic, readwrite) CLLocationDegrees _lat;

@property (nonatomic, readwrite) CLLocationDegrees _long;

 @property (nonatomic, readwrite) GMSMapView *mapView_;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

@end

