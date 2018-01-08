//
//  placeDictshareClass.h
//  NearMe
//
//  Created by Talentelgia on 23/07/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface placeDictshareClass : NSObject

@property (strong, nonatomic) NSString *place_Name;

@property (strong, nonatomic) NSString *place_Address;

@property (strong, nonatomic) NSString *place_Rating;

@property (strong, nonatomic) NSString *place_Distance;

@property (strong, nonatomic) NSString *place_ID;

@property (strong, nonatomic) NSString *place_photes;

+ (placeDictshareClass *)sharedInstance;

@end
