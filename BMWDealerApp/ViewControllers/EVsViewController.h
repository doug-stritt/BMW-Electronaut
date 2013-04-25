//
//  EVsViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnvironmentViewController.h"
#import "LifestyleViewController.h"
#import "RangeViewController.h"
#import "SavingsViewController.h"
#import "DSSliderController.h"

typedef enum evToolbarViewTypeTag
{
	kLifestyleScreen,
    kEnvironmentScreen,
    kSavingsScreen,
    kRangeScreen
} EVToolbarViewType;

@interface EVsViewController : UIViewController {
    
    EnvironmentViewController *environmentViewController;
    LifestyleViewController *lifestyleViewController;
    RangeViewController *rangeViewController;
    SavingsViewController *savingsViewController;
    
    // toolbar
    IBOutlet UIView *viewToolbar;
    IBOutlet UIButton *btnLifestyle;
    IBOutlet UIButton *btnEnvironment;
    IBOutlet UIButton *btnSavings;
    IBOutlet UIButton *btnRange;
    int intEVCurrentToolbarViewType;
    
    // caroushit
    IBOutlet UIView *viewCarousel;
    IBOutlet UIView *viewButtons;
    IBOutlet UIButton *btnCarouselLifestyle;
    IBOutlet UIButton *btnCarouselEnvironment;
    IBOutlet UIButton *btnCarouselSavings;
    IBOutlet UIButton *btnCarouselRange;
    
    IBOutlet DSSliderController *dsSliderController;
    IBOutlet UILabel *lblStartBy;
    IBOutlet UILabel *lblThenTap;
}

@property(nonatomic,retain) EnvironmentViewController *environmentViewController;
@property(nonatomic,retain) LifestyleViewController *lifestyleViewController;
@property(nonatomic,retain) RangeViewController *rangeViewController;
@property(nonatomic,retain) SavingsViewController *savingsViewController;

- (IBAction)lifestyleButtonSelected:(id)sender;
- (IBAction)environmentButtonSelected:(id)sender;
- (IBAction)savingsButtonSelected:(id)sender;
- (IBAction)rangeButtonSelected:(id)sender;
- (void)removeCurrentView;
- (void)animateCarousel;
- (void)displayIntroController;
- (void)loadSlider;

@end
