//
//  DSDialSlider.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/15/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DSDialSlider : UIViewController {
    
    IBOutlet UIView *viewDial;
    IBOutlet UILabel *lblDial1Miles1;
    IBOutlet UILabel *lblDial1Miles2;
    IBOutlet UILabel *lblDial1Miles3;
    IBOutlet UILabel *lblDial1Miles4;
    int intDial1StartCount;
    
    IBOutlet UIView *viewDial2;
    IBOutlet UILabel *lblDial2Miles1;
    IBOutlet UILabel *lblDial2Miles2;
    IBOutlet UILabel *lblDial2Miles3;
    IBOutlet UILabel *lblDial2Miles4;
    int intDial2StartCount;
    
    IBOutlet UILabel *lblMilesPer;
    
    BOOL isDay;
    
    IBOutlet UIView *viewClosed;
    IBOutlet UILabel *lblClosed;
    IBOutlet UILabel *lblIDriveClosed;
    IBOutlet UILabel *lblMilesPerClosed;
    
    IBOutlet UIImageView *imgViewTracksLeft;
    IBOutlet UIImageView *imgViewTracksRight;
    NSMutableArray *arrTracks;
    int intTrackCount;
    
    // value for closed slider lbl
    int intCurrentMiles;
    float flCurrentMiles;
    
    // miles already converted to day or year
    float flConvertedMiles;
    
    NSTimer *timerMoveDial;
    CGPoint touchLocation;
}

@property int intCurrentMiles;
@property float flCurrentMiles;
@property float flConvertedMiles;
@property BOOL isDay;

// Class Methods
+ (DSDialSlider*)sharedSlider;

- (void)setDial1;
- (void)setDial2;
- (void)toggleDayYear;
- (void)findClosestValue;
-(void) startTimer:(float)flTimeInterval;
-(void) stopTimer;
-(void) moveDial;
- (void)setDialToggle1;
- (void)setDialToggle2;

@end
