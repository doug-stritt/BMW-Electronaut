//
//  RangeViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "RangeViewController.h"
#import "JSONKit.h"
#import "MapAnnotation.h"
#import "CSImageAnnotationView.h"
#import "AudioManager.h"

@implementation RangeViewController

@synthesize poiType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [driveView release];
    [borderView release];
    [annotations release];
    [entertainmentPins release];
    [chargingStationPins release];
    [shoppingPins release];
    [restaurantPins release];
    [poiType release];
    [locManager release];
    [mapView release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderOpened) name:@"SliderOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDriveRadius) name:@"SliderClosed" object:nil];
    
    // Settings
    isLoading = YES;
    annotations = [[NSMutableArray alloc] init];
    entertainmentPins = [[NSMutableArray alloc] init];
    chargingStationPins = [[NSMutableArray alloc] init];
    shoppingPins = [[NSMutableArray alloc] init];
    restaurantPins = [[NSMutableArray alloc] init];
    
    // Init map
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 1024, 567)];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    mapView.zoomEnabled = YES;
    [self.view insertSubview:mapView atIndex:0];
    
    // Init location
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(determineLocation) userInfo:nil repeats:NO];
    
    isExpandingCollapsing = NO;
    
    // slider
    isDaySelected = FALSE;
    //[self loadSlider];
    [self dayYearButtonSelected:nil];
    //btnDayYear.enabled = FALSE;
}


- (void)determineLocation
{
    [locManager startUpdatingLocation];
}


- (IBAction)toggleMap:(id)sender
{
    [[AudioManager sharedAudioManager] playClick3];
    
    if (!isExpandingCollapsing) {
        isExpandingCollapsing = YES;
        
        float animationTime = 1.0;
        UIButton *button = (UIButton *)sender;
        button.selected = !button.selected;
        
        // Expand
        if (button.selected) {
            
            scrollView.hidden = YES;
            
            // Background
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationTime];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [bgView setFrame:CGRectMake(0, bgView.frame.origin.y + 157, bgView.frame.size.width, bgView.frame.size.height)];
            [UIView commitAnimations];
            
            /*// Info
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView commitAnimations];*/
            
            /*// iOS4 Version
            [UIView animateWithDuration:0.5 animations:^
             {
                 [bgView setCenter:CGPointMake(bgView.center.x, bgView.center.y + 157)];	
             }];*/
            
        // Collapse
        } else {
            
            [NSTimer scheduledTimerWithTimeInterval:animationTime target:self selector:@selector(showSlider) userInfo:nil repeats:NO];
            
            // Background
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationTime];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [bgView setFrame:CGRectMake(0, bgView.frame.origin.y - 157, bgView.frame.size.width, bgView.frame.size.height)];
            [UIView commitAnimations];
            
            /*// Info
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            [UIView setAnimationDelay:0.3];
            infoView.alpha = 1.0;
            [UIView commitAnimations];*/
            
            /*// iOS4 Version
            [UIView animateWithDuration:0.5 animations:^
             {
                 [bgView setCenter:CGPointMake(bgView.center.x, bgView.center.y - 157)];	
             }];*/
        }
        
        [NSTimer scheduledTimerWithTimeInterval:animationTime target:self selector:@selector(toggleMapComplete) userInfo:nil repeats:NO];
    }
}


- (void)toggleMapComplete
{
    isExpandingCollapsing = NO;
}


- (void)showSlider
{
    scrollView.hidden = NO;
}


- (IBAction)showVideo:(id)sender
{
    NSString *movieName = @"Range_SM";
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"True", @"hasControls", @"True", @"fadeIn", @"True", @"fadeOut", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
}


- (IBAction)toggleGroup:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    switch (button.tag) {
        // Entertainment
        case 1 :
            for (MKPinAnnotationView *pinView in entertainmentPins) pinView.hidden = !button.selected;
            break;
            
        // Charging Stations
        case 2 :
            for (MKPinAnnotationView *pinView in chargingStationPins) pinView.hidden = !button.selected;
            break;
            
        // Shopping
        case 3 :
            for (MKPinAnnotationView *pinView in shoppingPins) pinView.hidden = !button.selected;
            break;
            
        // Restaurants
        case 4 :
            for (MKPinAnnotationView *pinView in restaurantPins) pinView.hidden = !button.selected;
            break;
            
        default:
            break;
    }
}


- (void)loadDealerships
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dealerships" ofType:@"json"];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSData *data = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    NSDictionary *jsonData = [jsonKitDecoder objectWithData:data];
    NSArray *dealershipData = [jsonData objectForKey:@"dealerships"];
    
    //NSLog(@"Check %i Dealerships with Radius %i", [dealershipData count], BORDER_RADIUS);
    //NSLog(@"Current Location: %f %f", currentLoc.coordinate.latitude, currentLoc.coordinate.longitude);
    
    // Returns the dealerships within range
    NSIndexSet *dealershipsInRange = [dealershipData indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // Dealership location
        CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[[obj objectForKey:@"latitude"] floatValue] longitude:[[obj objectForKey:@"longitude"] floatValue]] autorelease];
        
        // Distance compare
        if ([currentLoc distanceFromLocation:loc] < BORDER_RADIUS) {
            //*stop = YES; // Only returns 1 point
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    // Initiate queries with current stations
    [dealershipsInRange enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         MapAnnotation *annotation;
         CLLocationCoordinate2D coord;
         coord.latitude = [[[dealershipData objectAtIndex:idx] objectForKey:@"latitude"] floatValue];
         coord.longitude = [[[dealershipData objectAtIndex:idx] objectForKey:@"longitude"] floatValue];
         annotation = [[[MapAnnotation alloc] initWithCoordinate:coord] autorelease];
         annotation.title = [[dealershipData objectAtIndex:idx] objectForKey:@"name"];
         annotation.type = @"Charging Station";
         [annotations addObject:annotation];
     }];
    
    //NSLog(@"Dealership Check Complete - found %i dealers nearby", [dealershipsInRange count]);
    
    // Load Charging Stations
    [self loadChargingStations];
}


- (void)loadChargingStations
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"charging-stations" ofType:@"json"];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSData *data = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    NSDictionary *jsonData = [jsonKitDecoder objectWithData:data];
    NSArray *stationData = [jsonData objectForKey:@"fuel_stations"];
    //NSLog(@"Stations = %@", stationData);
    
    //NSLog(@"Check %i Charging Stations with Radius %i", [stationData count], BORDER_RADIUS);
    
    // Returns the stations within range
    NSIndexSet *stationsInRange = [stationData indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        
        // Station location
        CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[[obj objectForKey:@"latitude"] floatValue] longitude:[[obj objectForKey:@"longitude"] floatValue]] autorelease];
        
        // Distance compare
        if ([currentLoc distanceFromLocation:loc] < BORDER_RADIUS) {
            //*stop = YES; // Only returns 1 point
            return YES;
        }
        else
        {
            return NO;
        }
    }];
    
    // Initiate queries with current stations
    [stationsInRange enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
    {
        MapAnnotation *annotation;
        CLLocationCoordinate2D coord;
        coord.latitude = [[[stationData objectAtIndex:idx] objectForKey:@"latitude"] floatValue];
        coord.longitude = [[[stationData objectAtIndex:idx] objectForKey:@"longitude"] floatValue];
        annotation = [[[MapAnnotation alloc] initWithCoordinate:coord] autorelease];
        annotation.title = [[stationData objectAtIndex:idx] objectForKey:@"station_name"];
        annotation.type = @"Charging Station";
        [annotations addObject:annotation];
    }];
    
    //NSLog(@"Charging Station Check Complete - found %i Stations nearby", [stationsInRange count]);
    
    // Load POI data
    [self updateHud:@"Loading Restaurants..."];
    [self checkPOI];
    
    // Skip POI data
    //[self displayPOIs];
}


- (void)checkPOI
{
    switch (poiIndex) {
        case 0 :
            poiType = @"restaurant";
            break;
            
        case 1 :
            poiType = @"cafe";
            break;
            
        case 2 :
            poiType = @"bar";
            break;
            
        case 3 :
            poiType = @"electronics_store";
            break;
            
        case 4 :
            poiType = @"clothing_store";
            break;
            
        case 5 :
            poiType = @"department_store";
            break;
            
        case 6 :
            poiType = @"furniture_store";
            break;
            
        case 7 :
            poiType = @"museum";
            break;
            
        case 8 :
            poiType = @"night_club";
            break;
            
        case 9 :
            poiType = @"movie_theater";
            break;
            
        default:
            break;
    }
    
    //NSLog(@"NEW POI: %@", poiType);
    
    // Update HUD
    if ([poiType isEqualToString:@"electronics_store"]) {
        HUD.labelText = @"Loading Shopping...";
    } else if ([poiType isEqualToString:@"museum"]) {
        HUD.labelText = @"Loading Entertainment...";
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadPOI) userInfo:nil repeats:NO];
    
}


- (void)loadPOI
{
    NSString *POIurl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=80467&types=%@&sensor=true&key=AIzaSyDcOkf5y1lpdLXL_G6t5wzRzr8sXVJxO1g", lat, lng, poiType];
    //NSLog(@"URL: %@", POIurl);
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:POIurl]];
	[request setDelegate:self];
    [request startAsynchronous];
}


- (void)displayPOIs
{
    [self displayMapRadius];
    [mapView addAnnotations:annotations];
    
    entertainmentBtn.selected = YES;
    chargingStationsBtn.selected = YES;
    shoppingBtn.selected = YES;
    restaurantsBtn.selected = YES;
    
    if (HUD != nil) [self hideHud];
    isLoading = NO;
}


- (void)displayMapRadius
{
    // Border
    MKCircle *borderCircle = [MKCircle circleWithCenterCoordinate:currentLoc.coordinate radius:BORDER_RADIUS];
    [mapView insertOverlay:borderCircle atIndex:0];
    
    float radius;
    // Day
    if ([dsDialSlider isDay]) radius = dsDialSlider.flConvertedMiles;
    // Year
    else radius = (dsDialSlider.flCurrentMiles * 1000)/365;
    
    // Drive
    MKCircle *driveCircle = [MKCircle circleWithCenterCoordinate:currentLoc.coordinate radius:radius * 609.344]; // (1 Mile = 609.344 Meters)
    [mapView insertOverlay:driveCircle atIndex:0];
}


- (void)updateDriveRadius
{
    if (driveView != nil) [driveView removeFromSuperview];
    
    float radius;
    // Day
    if ([dsDialSlider isDay]) radius = dsDialSlider.flConvertedMiles;
    // Year
    else radius = (dsDialSlider.flCurrentMiles * 1000)/365;
    
    MKCircle *driveCircle = [MKCircle circleWithCenterCoordinate:currentLoc.coordinate radius:radius * 609.344]; // (1 Mile = 609.344 Meters)
    [mapView insertOverlay:driveCircle atIndex:0];
}


- (void)requestFinished:(ASIHTTPRequest *)req
{
    //NSLog(@"responseString: %@", [req responseString]);
    request = nil;
    
    // Convert server response to JSON
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSData *data = [[req responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *items = [jsonKitDecoder objectWithData:data];
    NSArray *results = [items objectForKey:@"results"];
    //NSLog(@"POI Count: %i", [results count]);
    
    MapAnnotation *annotation;
    CLLocationCoordinate2D coord;
    for (NSDictionary *POIdict in results) {
        //NSLog(@"NAME: %@ LAT: %@ LNG: %@", [POIdict objectForKey:@"name"], [[[POIdict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"], [[[POIdict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]);
        coord.latitude = [[[[POIdict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
        coord.longitude = [[[[POIdict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        annotation = [[[MapAnnotation alloc] initWithCoordinate:coord] autorelease];
        annotation.title = [POIdict objectForKey:@"name"];
        
        // POI Type
        // Restaurant
        if ([poiType isEqualToString:@"restaurant"] || [poiType isEqualToString:@"cafe"] || [poiType isEqualToString:@"bar"]) annotation.type = @"Restaurant";
        
        // Shopping
        else if ([poiType isEqualToString:@"electronics_store"] || [poiType isEqualToString:@"clothing_store"] || [poiType isEqualToString:@"department_store"] || [poiType isEqualToString:@"furniture_store"]) annotation.type = @"Shopping";
        
        // Entertainment
        else if ([poiType isEqualToString:@"museum"] || [poiType isEqualToString:@"night_club"] || [poiType isEqualToString:@"movie_theater"]) annotation.type = @"Entertainment";
        
        [annotations addObject:annotation];
    }
    
    // Update POI type
    poiIndex++;
    
    // Load next POI
    if (poiIndex < 10) [self checkPOI];
    
    // Else add all POIs to map
    else [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(displayPOIs) userInfo:nil repeats:NO];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSLog(@"GOOGLE PLACES QUERY FAILED");
    [self updateHud:@"Loading Failed - Check Your Internet Connection"];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(skipPOIs) userInfo:nil repeats:NO];
}


- (void)skipPOIs
{
    [self displayMapRadius];
    [mapView addAnnotations:annotations];
    
    chargingStationsBtn.selected = YES;
    entertainmentBtn.enabled = NO;
    restaurantsBtn.enabled = NO;
    shoppingBtn.enabled = NO;
    
    [self hideHud];
}


- (void)sliderOpened
{
    questionBtn.hidden = NO;
    imgViewPersonalize.hidden = YES;
    titleView.hidden = NO;
    lblTitle.text = @"Put your range anxiety to rest. \nView the map to see how far a BMW ActiveE can take you every day.";
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locManager stopUpdatingLocation];
    
    // Set the current location
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
    currentLat = lat;
    currentLng = lng;
    currentLoc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    // Set the map to that location and allow user interaction
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, MAP_RADIUS, MAP_RADIUS);
    [mapView setRegion:region animated:YES];
    
    // Load Charging Stations
    [self showHud:@"Loading Charging Stations..."];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadDealerships) userInfo:nil repeats:NO];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@", [error description]);
}


#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation 
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MapAnnotation *mapAnnotation = annotation;

    // Reuse existing image
	NSString *CSIdentifier = @"CSImageAnnotation";
    CSImageAnnotationView *poiImage = (CSImageAnnotationView *)[mv dequeueReusableAnnotationViewWithIdentifier:CSIdentifier];
    
	if(poiImage == nil)
	{
		poiImage = [[[CSImageAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CSIdentifier] autorelease];
		poiImage.canShowCallout = YES;
        poiImage.rightCalloutAccessoryView = nil;
	}
    
    // Determine pin image
    // Restaurants
    if ([mapAnnotation.type isEqualToString:@"Restaurant"]) {
        poiImage.myImage = [UIImage imageNamed:@"range-pin-restaurant.png"];
        [restaurantPins addObject:poiImage];
        
    // Shopping
    } else if ([mapAnnotation.type isEqualToString:@"Shopping"]) {
        poiImage.myImage = [UIImage imageNamed:@"range-pin-shopping.png"];
        [shoppingPins addObject:poiImage];
        
    // Entertainment
    } else if ([mapAnnotation.type isEqualToString:@"Entertainment"]) {
        poiImage.myImage = [UIImage imageNamed:@"range-pin-entertainment.png"];
        [entertainmentPins addObject:poiImage];
        
    // Charging Station
    } else if ([mapAnnotation.type isEqualToString:@"Charging Station"]) {
        poiImage.myImage = [UIImage imageNamed:@"range-pin-charging-station.png"];
        [chargingStationPins addObject:poiImage];
    }
    
	[poiImage setNeedsLayout];
    
	return poiImage;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircle *circle = (MKCircle *)overlay;
    MKCircleView *circleView;
    
    // Border
    if (circle.radius == BORDER_RADIUS) {
        borderView = [[MKCircleView alloc] initWithCircle:circle];
        borderView.strokeColor = [[UIColor alloc] initWithRed:38.0/255.0 green:85.0/255.0 blue:137.0/255.0 alpha:0.8];
        borderView.lineWidth = 10.0;
        circleView = borderView;
    
    // Drive
    } else {
        if (driveView != nil) [driveView removeFromSuperview];
        
        driveView = [[MKCircleView alloc] initWithCircle:circle];
        driveView.fillColor = [[UIColor alloc] initWithRed:0.0/255.0 green:170.0/255.0 blue:255.0/255.0 alpha:0.4];
        circleView = driveView;
    }
    
    return circleView;
}


#pragma mark - slider methods

- (void)loadSlider
{
    dsDialSlider = [DSSliderController sharedSlider];
    dsDialSlider.view.frame = CGRectMake(0, 18, 592, 223);
    [scrollView addSubview:dsDialSlider.view];
    
    [dsDialSlider initClosedState:FALSE];
    if (![dsDialSlider isDay]) [dsDialSlider toggleDayYear];
}


- (IBAction)dayYearButtonSelected:(id)sender
{
    if (isDaySelected) {
        isDaySelected = FALSE;
        [btnDayYear setBackgroundImage:[UIImage imageNamed:@"dayYearSel"] forState:UIControlStateNormal];
    } else {
        isDaySelected = TRUE;
        [btnDayYear setBackgroundImage:[UIImage imageNamed:@"daySelYear"] forState:UIControlStateNormal];
    }
    
    [dsDialSlider toggleDayYear];
}


- (IBAction)helpButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick2];
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"range", @"section", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
}


#pragma mark - HUD
- (void)showHud:(NSString *)hudTitle
{
	// The hud will disable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = hudTitle;
	
	// Show the HUD
    [HUD show:YES];
}

- (void)updateHud:(NSString *)hudTitle
{
    HUD.labelText = hudTitle;
}


- (void)hideHud
{
	if (HUD != nil) [HUD hide:YES];
}


- (void)hudWasHidden
{
    [HUD removeFromSuperview];
	HUD = nil;
    [HUD release];
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
