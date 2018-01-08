//
//  WebServicManager.m
//  NearMe
//
//  Created by Talentelgia on 6/19/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "WebServicManager.h"
#import "Constant.h"

@implementation WebServicManager{
    Reachability* internetReachable;
    Reachability* hostReachable;
}
+(NSMutableDictionary*)getApiRequestResponse:(NSString*)query hideView:(UIView*)hideView{
    @try {
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[query stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
        NSData *respData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict = [NSJSONSerialization JSONObjectWithData:respData options:kNilOptions error:&error];
                // [MBProgressHUD hideHUDForView:hideView animated:YES];
                return dict;
        
    }
    @catch (NSException *exception) {
        
    }
  
}
-(int)checkForNetworkStatus{
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    return [self checkNetwork];
    
}
-(int) checkNetwork
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            return internetStatus;
            
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
             return internetStatus;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
             return internetStatus;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
             return internetStatus;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
             return internetStatus;
            
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
             return internetStatus;
            break;
        }
    }
     return internetStatus;
}
+(void)showAlertView:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert  show];
    
}
@end
