//
//  LifestyleViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSSliderController.h"

@interface LifestyleViewController : UIViewController  {
    
    // slider
    IBOutlet DSSliderController *dsDialSlider;
    IBOutlet UIButton *btnDayYear;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblSubtitle;
    IBOutlet UIImageView *imgViewMainTitle;
    IBOutlet UIButton *btnHelp;
    BOOL isDaySelected;
}

- (IBAction)showEVVideo:(id)sender;
- (IBAction)showPioneersVideo:(id)sender;
- (IBAction)questionClick:(id)sender;

- (IBAction)dayYearButtonSelected:(id)sender;
- (IBAction)helpButtonSelected:(id)sender;
- (void)updateEnvironmentLabel;
- (void)loadSlider;

@end
