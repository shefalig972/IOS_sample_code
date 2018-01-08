//
//  CategoryViewController.m
//  NearMe
//
//  Created by Talentelgia on 6/30/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "CategoryViewController.h"
#import "Constant.h"
#import "placeDictshareClass.h"
@import GoogleMobileAds;



@interface CategoryViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,GADAdDelegate,GADAdLoaderDelegate,GADBannerViewDelegate> {
    
    
    // Local variable
    IBOutlet UITableView *table_view;
    
    IBOutlet UISegmentedControl *segment_control;
    
    IBOutlet UIView *searchView;
    

    IBOutlet UISlider *slider;
    
    IBOutlet UILabel  *distanceLabel; //Check the user selected range.
    
    IBOutlet GADBannerView *bannerView;
    
    
    //For GMSMap background View;
    IBOutlet UIView *gmsBgView;
    
    IBOutlet UISearchBar    *search_Bar;
    
    IBOutlet UIButton *searchButton;
    
    BOOL searchFlag;
    
    
    
    //Google Map View
    GMSMapView *mapView_;
    
    //gms camera
    GMSCameraPosition *camera;
    
    //for Google range circle
    GMSCircle *circ;
    
    CLLocationCoordinate2D circleCenter;
    
    
    //CategoryArray (plist data)
    NSArray *categoryArray;
    
    NSIndexPath *selectedIndex;
    
}
@end

@implementation CategoryViewController

- (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        
        context = [delegate managedObjectContext];
        
    }
    
    return context;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add BannerView
    bannerView.delegate = self;
    bannerView.adUnitID = @"ca-app-pub-4464885979342199/7612388069";
    bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [bannerView loadRequest:request];
    

    
    self.title = @"NearMe";  //Set navigation title

    //Get the documents directory path of PropertyList_files
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PropertyList_files" ofType:@"plist"];
    
    //Get property list data
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    //Get category array
    categoryArray = [[[myDictionary valueForKey:@"category_DataList"] reverseObjectEnumerator] allObjects];
    
    
    
    /*Hidden the search view (check the rang of category types)*/
    // hidden map view.
    [segment_control setSelectedSegmentIndex:0];
    
    [self segmentAction:segment_control];

    
    // Tap gesture for dismiss key board on searchView.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [searchView addGestureRecognizer:tap];
  
    
    // Set search bar image for set the clear background.
    search_Bar.backgroundImage = [UIImage new];
    
    [gmsBgView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    [gmsBgView.layer setShadowOffset:CGSizeMake(0, 0)];
    
    gmsBgView.layer.shadowOpacity = 0.7;
    
    
    // Set button style.
    [self setSearchButtonProperties];
    
    //Set navigation bar buttons
    [self setNavigationBarButton];
    
    // current location
    [LocationManagerSingleton sharedSingleton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigation bar buttons
- (void)setNavigationBarButton {
    
    //Set navigation leftbarbutton (favorite view)
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"favorite_image"] style:UIBarButtonItemStylePlain target:self action:@selector(favouriteButtonAction:)];
    
    leftBarButton.image = [leftBarButton.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
}

#pragma mark - Set Search Button Properties.
- (void)setSearchButtonProperties {
    
    //Search button properties.
    searchButton.layer.cornerRadius = 5;
    
    searchButton.layer.borderWidth = 2.0f;
    
    searchButton.layer.borderColor = [UIColor colorWithRed:216.0f/255.0f green:9.0f/255.0f blue:45.0f/255.0f alpha:1].CGColor;
    
}

#pragma  mark - UITableView Delegates And DataSoruces Methods.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.cellLabel.text = [[categoryArray valueForKey:@"name"] objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[[categoryArray valueForKey:@"imagename"] objectAtIndex:indexPath.row]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectedBackgroundView = [UIView new];
    
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index.....%ld",(long)indexPath.row);
    
    selectedIndex = indexPath;
    
    NSDictionary* selectedDict = [categoryArray objectAtIndex:indexPath.row];
    
    search_Bar.text = [selectedDict objectForKey:@"name"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [segment_control setSelectedSegmentIndex:1];
    
    [self segmentAction:segment_control];
    
}


#pragma  mark -- Segment Button Action
- (IBAction)segmentAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        // show first view.
        table_view.hidden =  NO;
        
        // hidden second view.
        searchView.hidden = YES;
        
        [mapView_ removeFromSuperview];
        
        [search_Bar resignFirstResponder];
        
        search_Bar.text = @"";
        
        searchFlag = YES;
        
    }else {
        
        //hidden first view.
        table_view.hidden=YES;

        // show second view.
        searchView.hidden = NO;
        
        [self showMapView];
        
    }
    
}


#pragma  mark -- Slider Action
//Slider Action
- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    float sliderValue = sender.value / 5;
    
    slider.value = ceil(sliderValue)*5;
    
    [mapView_ clear];
    
    distanceLabel.text = [NSString stringWithFormat:@"%d Km",(int)(slider.value)];
    
    int range = (int)slider.value*1000;
    
    circ = [GMSCircle circleWithPosition:circleCenter radius:range];
    
    circ.fillColor = [UIColor colorWithRed:57/255.0f green:117/255.0f blue:254/255.0f alpha:0.3];
    
    circ.strokeColor = [UIColor blueColor];
    
    circ.strokeWidth = 2;
    
    circ.map = mapView_;
    
    float zoomValue = 10.1 - (0.04 * (range / 1000));
    
    CLLocationCoordinate2D  coordinates = CLLocationCoordinate2DMake(DELEGATE.currentPoints.latitude,DELEGATE.currentPoints.longitude);
    
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinates zoom:zoomValue];
    
    [mapView_ animateWithCameraUpdate:updatedCamera];
    
}


#pragma  mark -- Search Button Action
//Search Button Action
- (IBAction)searchButtonAction:(id)sender {
    
    
    SHOW_LOADING();
        
    NSString* placeURL;
    
    // user search flag == YES for category
    if(searchFlag == YES) {
        
        placeURL = [NSString stringWithFormat:@"%@/search/json?location=%f,%f&radius=%.2f&types=%@&sensor=true&key=%@",placeBaseURL, DELEGATE.currentPoints.latitude, DELEGATE.currentPoints.longitude, (slider.value * 1000), [[categoryArray objectAtIndex:selectedIndex.row] objectForKey:@"type"], place_api_key];
        
    }else {
        
        NSString *s = search_Bar.text;
        
        NSArray *comps = [s componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSMutableArray *words = [NSMutableArray array];
        
        for(NSString *comp in comps) {
            
            if([comp length] > 1) {
                [words addObject:comp];
            }
            
        }
        
   
        NSString *query = [words componentsJoinedByString:@"+"];
        
        placeURL = [NSString stringWithFormat:@"%@/textsearch/json?location=%f,%f&radius=5000&query=%@&sensor=true&key=%@", placeBaseURL, DELEGATE.currentPoints.latitude, DELEGATE.currentPoints.longitude, query, place_api_key];

    }
    
    
    if(placeURL.length > 0) {
    
        
        NSURLSession *session_placeURL = [NSURLSession sharedSession];
        
        [[session_placeURL dataTaskWithURL:[NSURL URLWithString:placeURL] completionHandler:^(NSData *place_data, NSURLResponse *place_response, NSError *place_error) {
                    // handle response
            
            if (place_error) {
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    // Do something...
                    dispatch_async(dispatch_get_main_queue(), ^{
                        HIDE_LOADING();
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:place_error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }); //end dispatch_get_main_queue
                    
                }); //end dispatch_get_global_queue
                
            }else {
            
                // get place url data
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:place_data options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"selected category data %@", dict);
                
                NSArray *place_Info = [dict objectForKey:@"results"];
                
                if ([[dict valueForKey:@"status"] isEqualToString:@"ZERO_RESULTS"] || [[dict valueForKey:@"status"] isEqualToString:@"INVALID_REQUEST"]) {
                    
            
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                        // Do something...
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No data found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }); // end dispatch_get_main_queue
                        
                    }); // end dispatch_get_global_queue

                    
                    
                }
                
                //send array to place info class
                NSMutableArray* send_placeInfo_Array = [NSMutableArray new];
                
                 // get place info dictionary
                 for (NSDictionary *get_Dict in place_Info) {
                    
                        CLLocationDirection destination_lat = [get_Dict[@"geometry"][@"location"][@"lat"] floatValue];
                        CLLocationDirection destination_long = [get_Dict[@"geometry"][@"location"][@"lng"] floatValue];
                        
                        //Get Distance between source to destination.
                        NSString *distanceQuery = [NSString stringWithFormat:@"%@origins=%f,%f&destinations=%f,%f&key=%@", distanceMatrixApi, DELEGATE.currentPoints.latitude, DELEGATE.currentPoints.longitude, destination_lat,destination_long, place_api_key];
                        
                        NSURLSession *session_distanceQuery = [NSURLSession sharedSession];
                    
                        [[session_distanceQuery dataTaskWithURL:[NSURL URLWithString:distanceQuery] completionHandler:^(NSData *distance_data, NSURLResponse *distance_response, NSError *distance_error) {
                            // handle response
                            
                            if (distance_error) {
                                
                                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                
                                            // Do something...
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                HIDE_LOADING();
                                                [[[UIAlertView alloc] initWithTitle:@"Error" message:distance_error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                            }); // end dispatch_get_main_queue
                                                
                                        }); // end dispatch_get_global_queue
                                        
                            }else {
                                
                                        // get place url data
                                        NSDictionary* get_place_distance = [NSJSONSerialization JSONObjectWithData:distance_data options:NSJSONReadingMutableContainers error:nil];
                                
                                        NSLog(@"get distance %@", get_place_distance);
                                
                                        // create place info class
                                        placeDictshareClass *placeInfoClass = [placeDictshareClass new];
                                
                                        placeInfoClass.place_Name = [get_Dict objectForKey:@"name"];
                                
                                        if (searchFlag == YES) {
                                            
                                            placeInfoClass.place_Address = [get_Dict objectForKey:@"vicinity"];
                                            
                                        }
                                        else {
                                            
                                            placeInfoClass.place_Address = [get_Dict objectForKey:@"formatted_address"];
                                            
                                        }
                                
                                        placeInfoClass.place_Rating =  [get_Dict objectForKey:@"rating"];
                                
                                        placeInfoClass.place_Distance = [[[[[[get_place_distance objectForKey:@"rows"] firstObject] objectForKey:@"elements"] firstObject] objectForKey:@"distance"] objectForKey:@"text"];
                                
                                        placeInfoClass.place_ID = [get_Dict valueForKey:@"place_id"];
                                
                                        placeInfoClass.place_photes = [[[get_Dict objectForKey:@"photos"] firstObject] valueForKey:@"photo_reference"];
                                        
                                        [send_placeInfo_Array addObject:placeInfoClass];  //Add place info class in array
                                
                                
                                        if (place_Info.count == send_placeInfo_Array.count) {
                                            
                                                //hidden MBprogressHUD.
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [self callPlaceInfoViewController:send_placeInfo_Array titleName:search_Bar.text];
                                                        
                                                        HIDE_LOADING();
                                                        
                                                    }); // end dispatch_get_main_queue
                                                    
                                                }); // enddispatch_get_global_queue
                                            
                                        } //end  if (place_Info.count == send_placeInfo_Array.count)
                            
                                
                            }// else end
                            
                            
                        }] resume]; // end distanceSession
                     
                } // end for loop

            }// end else
            
        }] resume]; // end placeSession
        
    }

}


#pragma mark -
#pragma  mark - searchBar delegate methods
-(void)dismissKeyboard {
    [search_Bar resignFirstResponder];
}

// It is important for you to hide the keyboard
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchFlag = NO;
    return YES;
}

-(void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
  
        [self searchButtonAction:searchButton];
        
    
}

#pragma mark -
#pragma mark - Show google mapView
-(void)showMapView {
    
    camera = [GMSCameraPosition cameraWithLatitude:DELEGATE.currentPoints.latitude   longitude:DELEGATE.currentPoints.longitude   zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(CGRectGetMinX(gmsBgView.frame), CGRectGetMinY(gmsBgView.frame)+105, CGRectGetWidth(gmsBgView.frame), CGRectGetHeight(gmsBgView.frame)) camera:camera];
    
    mapView_.myLocationEnabled = YES;
    
    mapView_.settings.compassButton = YES;
    
    mapView_.settings.myLocationButton = YES;
    
    
    circleCenter = CLLocationCoordinate2DMake(DELEGATE.currentPoints.latitude, DELEGATE.currentPoints.longitude);
    
    circ = [GMSCircle circleWithPosition:circleCenter radius:5000];
    
    circ.fillColor = [UIColor colorWithRed:57/255.0f green:117/255.0f blue:254/255.0f alpha:0.3];
    
    circ.strokeColor = [UIColor blueColor];
    
    circ.strokeWidth = 2;
    
    circ.map = mapView_;
    
    [self.view addSubview:mapView_];
    
}

#pragma mark - call favourite button.
- (void)favouriteButtonAction:(id)sender {
    
    SHOW_LOADING();
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
    NSArray *favouriteArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"%lu",(unsigned long)favouriteArray.count);
    
    NSMutableArray *send_placeInfo_Array = [NSMutableArray new];
    
    if (favouriteArray.count > 0) {
        __block int i = 0;
        for (NSManagedObject *favouriteObject in favouriteArray) {
            
            //Get Distance between source to destination.
            NSString *distanceQuery = [NSString stringWithFormat:@"%@origins=%f,%f&destinations=%f,%f&key=%@", distanceMatrixApi, DELEGATE.currentPoints.latitude, DELEGATE.currentPoints.longitude, [[favouriteObject valueForKey:@"latitude"] floatValue], [[favouriteObject valueForKey:@"longitude"] floatValue], place_api_key];
            
            NSURLSession *session_distanceQuery = [NSURLSession sharedSession];
            
            [[session_distanceQuery dataTaskWithURL:[NSURL URLWithString:distanceQuery] completionHandler:^(NSData *distance_data, NSURLResponse *distance_response, NSError *distance_error) {
                // handle response
                
                if (distance_error) {
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        // Do something...
                        dispatch_async(dispatch_get_main_queue(), ^{
                            HIDE_LOADING();
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:distance_error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        });
                    });
                    
                }else {
                    
                    // get place url data
                    NSDictionary* get_place_distance = [NSJSONSerialization JSONObjectWithData:distance_data options:NSJSONReadingMutableContainers error:nil];
                    
                    // NSLog(@"get distance %@", get_place_distance);
                    
                    // create place info class
                    placeDictshareClass *placeInfoClass = [placeDictshareClass new];
                    placeInfoClass.place_Name = [favouriteObject valueForKey:@"name"];
                    placeInfoClass.place_Address = [favouriteObject valueForKey:@"vicinity"];
                    placeInfoClass.place_Rating =  [favouriteObject valueForKey:@"rating"];
                    placeInfoClass.place_Distance = [[[[[[get_place_distance objectForKey:@"rows"] firstObject] objectForKey:@"elements"] firstObject] objectForKey:@"distance"] objectForKey:@"text"];
                    placeInfoClass.place_ID = [favouriteObject valueForKey:@"place_id"];
                    placeInfoClass.place_photes = [favouriteObject valueForKey:@"photo_reference"];
                    
                    
                    [send_placeInfo_Array addObject:placeInfoClass];  //Add place info class in array
                    
                    i++;//increment for check the count.
                    NSLog(@"%d",i);

                    
                    if (i == favouriteArray.count) {
                        
                        //hidden MBprogressHUD.
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            // Do something...
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self callPlaceInfoViewController:send_placeInfo_Array titleName:@"Favourites"];
                                
                                HIDE_LOADING();
                            });
                        });
                        
                    }
                    
                }// else end
                
                
            }] resume]; // end distanceSession
            
        }
        
    }else {

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                HIDE_LOADING();
                [[[UIAlertView alloc] initWithTitle:@"Favourites" message:@"No Data Found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        });
    }
    
}


- (void)callPlaceInfoViewController:(NSArray *)sendArray titleName:(NSString *)title {
    
    //push to place info view controller.
    PlacesInfoViewController *placeInfoView = [[PlacesInfoViewController alloc]initWithNibName:@"PlacesInfoViewController" bundle:[NSBundle mainBundle]];
    placeInfoView.display_Info_Array = sendArray;
    placeInfoView.navigateTitile = title;
    UIImage *image;
    if (searchFlag == YES) {
               image = [UIImage imageNamed:[[categoryArray valueForKey:@"imagename"] objectAtIndex:selectedIndex.row]];
        
    }
    else{
        image = [UIImage imageNamed:@"searchDefault_image"];
    }
    placeInfoView.defaultImage = image;
    [self.navigationController pushViewController:placeInfoView animated:YES];
    
}


#pragma mark - GADBannerViewDelegate

// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    //bannerView.hidden = NO;
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Called when an ad request failed.
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error.localizedDescription);
}

// Called just before presenting the user a full screen view, such as a browser, in response to
// clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Called just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Called just after dismissing a full screen view.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// Called just before the application will background or terminate because the user clicked on an ad
// that will launch another application (such as the App Store).
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(GADRequestError *)error;{
    
}


@end
