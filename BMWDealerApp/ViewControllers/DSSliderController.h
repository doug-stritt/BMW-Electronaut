//
//  DSSliderController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 10/18/11.
//  Copyright (c) 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSSliderController : UIViewController <UIScrollViewDelegate> {
    
    IBOutlet UIView *viewSlider;
    IBOutlet UIScrollView *scrViewMiles;
    IBOutlet UIImageView *imgViewBorder;
    IBOutlet UIButton *btnMinus;
    IBOutlet UIButton *btnPlus;
    IBOutlet UILabel *lblMiles;
    
    NSTimer *timerMoveDial;
    NSTimer *timerCloseDial;
    
    BOOL isDay;
    BOOL isEVIntro;
    
    // closed view
    IBOutlet UIView *viewClosed;
    IBOutlet UILabel *lblClosed;
    IBOutlet UILabel *lblBasedClosed;
    IBOutlet UILabel *lblMilesPerClosed;
    
    // value for closed slider lbl
    int intCurrentMiles;
    float flCurrentMiles;
    
    // miles already converted to day or year
    float flConvertedMiles;
}

@property int intCurrentMiles;
@property float flConvertedMiles;
@property float flCurrentMiles;
@property BOOL isDay;
@property BOOL isEVIntro;

// Class Methods
+ (DSSliderController*)sharedSlider;

- (void)snapScrollView;
- (IBAction)minusButtonPressed:(id)sender;
- (IBAction)plusButtonPressed:(id)sender;
- (IBAction)buttonReleased:(id)sender;

- (void)startCloseTimer;
- (void)stopCloseTimer;
- (void)closeSlider;
- (void)initClosedState:(BOOL)isOpen;
- (void)resetSlider;

@end
