//
//  placeDictshareClass.m
//  NearMe
//
//  Created by Talentelgia on 23/07/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "placeDictshareClass.h"

@implementation placeDictshareClass
@synthesize place_Name, place_Address, place_Rating, place_Distance, place_ID, place_photes;

+ (placeDictshareClass *)sharedInstance {
    static dispatch_once_t once;
    static placeDictshareClass *instance;
    dispatch_once(&once, ^{
        instance = [[placeDictshareClass alloc] init];
    });
    return instance;
}

@end
