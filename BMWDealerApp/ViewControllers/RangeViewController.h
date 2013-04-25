//
//  RangeViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "DSSliderController.h"

#define MAP_RADIUS 67027 // 110 Miles (1 Mile = 609.344 Meters)
#define BORDER_RADIUS 60934 // 100 Miles (1 Mile = 609.344 Meters)


@interface RangeViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, ASIHTTPRequestDelegate, MBProgressHUDDelegate> {
    MKMapView *mapView;
    CLLocationManager *locManager;
    CLLocation *currentLoc;
    ASIHTTPRequest *request;
    MBProgressHUD *HUD;
    IBOutlet UIView *bgView;
    IBOutlet UIView *scrollView;
    IBOutlet UIImageView *legendView;
    IBOutlet UIImageView *titleView;
    IBOutlet UIImageView *imgViewPersonalize;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UIButton *questionBtn;
    IBOutlet UIButton *entertainmentBtn;
    IBOutlet UIButton *chargingStationsBtn;
    IBOutlet UIButton *shoppingBtn;
    IBOutlet UIButton *restaurantsBtn;
    NSMutableArray *annotations;
    NSMutableArray *annotationViews;
    NSMutableArray *entertainmentPins;
    NSMutableArray *chargingStationPins;
    NSMutableArray *shoppingPins;
    NSMutableArray *restaurantPins;
    NSString *poiType;
    MKCircleView *borderView;
    MKCircleView *driveView;
    float lat;
    float lng;
    float currentLat;
    float currentLng;
    int poiIndex;
    BOOL isLoading;
    BOOL isExpandingCollapsing;
    
    // slider
    IBOutlet DSSliderController *dsDialSlider;
    IBOutlet UIButton *btnDayYear;
    BOOL isDaySelected;
}

@property (nonatomic, retain) NSString *poiType;

- (IBAction)toggleMap:(id)sender;
- (IBAction)showVideo:(id)sender;
- (IBAction)toggleGroup:(id)sender;
- (IBAction)dayYearButtonSelected:(id)sender;
- (IBAction)helpButtonSelected:(id)sender;
- (void)loadChargingStations;
- (void)checkPOI;
- (void)loadPOI;
- (void)displayPOIs;
- (void)displayMapRadius;
- (void)showHud:(NSString *)hudTitle;
- (void)updateHud:(NSString *)hudTitle;
- (void)hideHud;
- (void)updateEnvironmentLabel;
- (void)loadSlider;

@end
