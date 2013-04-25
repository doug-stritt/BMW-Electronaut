//
//  SavingsViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreboardViewController.h"
#import "DSSliderController.h"

#define AVG_GAS_PRICE 3.568
#define MILES_PER_GALLON 22
#define CHARGING_COST 3.85
#define RANGE_PER_CHARGE 100


@interface SavingsViewController : UIViewController {
    
    IBOutlet UIImageView *scoreboardBG;
    IBOutlet UIImageView *imgViewMainTitle;
    IBOutlet UIImageView *imgViewPersonalize;
    IBOutlet UIButton *btnHelp;
    IBOutlet UILabel *lblTitle;
    ScoreboardViewController *scoreboardView;
    
    // slider
    IBOutlet DSSliderController *dsDialSlider;
    IBOutlet UIButton *btnDayYear;
    BOOL isDaySelected;
}

- (void)updateSavings;
- (IBAction)showVideo:(id)sender;
- (IBAction)dayYearButtonSelected:(id)sender;
- (IBAction)helpButtonSelected:(id)sender;
- (void)loadSlider;

@end
