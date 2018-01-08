//
//  WebServicManager.h
//  NearMe
//
//  Created by Talentelgia on 6/19/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface WebServicManager : NSObject

+(NSMutableDictionary*)getApiRequestResponse:(NSString*)query hideView:(UIView*)hideView;
+(void)showAlertView:(NSString*)message;
-(int)checkForNetworkStatus;

@end
