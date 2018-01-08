//
//  Constant.h
//  NearMe
//
//  Created by Talentelgia on 6/17/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#ifndef NearMe_Constant_h
#define NearMe_Constant_h


//Arrays
#define placeTypeArray @[@"atm",@"airport",@"amusement_park",@"bakery",@"bank",@"bus_station",@"beauty_salon",@"car_dealer",@"car_rental",@"car_repair",@"car_wash",@"cafe",@"clothing_store",@"courthouse",@"dentist",@"department_store",@"doctor",@"electrician",@"electronics_store",@"florist",@"funeral_home",@"furniture_store",@"gas_station",@"grocery_or_supermarket",@"gas_station",@"gym",@"hair_care",@"health",@"hindu_temple",@"Hotel",@"hospital",@"movie_theater",@"park",@"train_station",@"taxi_stand"]

#define displayArray @[@"Atm",@"Airport",@"Amusement Park",@"Bakery",@"Bank",@"Bus Stand",@"Beauty Salon",@"Car Dealer",@"Car Rental",@"Car Repair",@"Car Wash",@"Cafe",@"Clothing Store",@"Courthouse",@"Dentist",@"Department Store",@"Doctor",@"Electrician",@"Electronics Store",@"Florist",@"Funeral Home",@"Furniture Store",@"Gas Station",@"Grocery",@"Gas Station",@"Gym",@"Hair Care",@"Health",@"Hindu Temple",@"Hotel",@"Hospital",@"Movie Theater",@"Park",@"Railway Station",@"Taxi Stand"]

#define imageArray @[@"barImage",@"hotelimage",@"barImage",@"pumpImage",@"pumpImage",@"theaterimage",@"pumpImage",@"coffieImage",@"barImage",@"pumpImage",@"hospitalimage",@"hotelimage",@"barImage",@"pumpImage",@"pumpImage",@"theaterimage",@"barImage",@"pumpImage",@"coffieImage",@"barImage",@"pumpImage",@"hospitalimage",@"hotelimage",@"barImage",@"pumpImage",@"pumpImage",@"theaterimage",@"barImage",@"pumpImage",@"coffieImage",@"barImage",@"pumpImage",@"hospitalimage",@"barImage",@"pumpImage",@"coffieImage",@"barImage",@"pumpImage",@"hospitalimage"]



// Direction Api key
#define place_api_key       @"AIzaSyCmFVhuctrYVXzRliSEsC0g3BYOaTBnLRM"

// google api URL
#define placeBaseURL      @"https://maps.googleapis.com/maps/api/place"
#define cordinateApi         @"https://maps.googleapis.com/maps/api/directions/json?"
#define distanceMatrixApi @"https://maps.googleapis.com/maps/api/distancematrix/json?"


#define SCREEN_WINDOW       [[UIApplication sharedApplication] keyWindow]
#define HIDE_LOADING()         [MBProgressHUD hideHUDForView:SCREEN_WINDOW animated:NO]
#define SHOW_LOADING()        [MBProgressHUD showHUDAddedTo:SCREEN_WINDOW animated:NO]

#define IS_VALID_STRING(_str_) _str_ && ![_str_ isEqual:[NSNull null]] && ![_str_ isEqualToString:@"(null)"]  ? TRUE : FALSE

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])


//frameworks
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

// ViewController
#import "AppDelegate.h"
#import "HomeTableViewCell.h"
#import "CategoryViewController.h"
#import "PlacesInfoViewController.h"
#import "PlacesInfoTableViewCell.h"
#import "PlaceDescriptionViewController.h"
#import "FirstIndexTableViewCell.h"

//Helper classes
#import "LocationManagerSingleton.h"
#import "MBProgressHUD.h"
#import "WebServicManager.h"

#endif
