//
//  ActiveEBMWViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveEPopupView.h"


@interface ActiveEElectricViewController : UIViewController {
    IBOutlet UIButton *electricBtn;
    IBOutlet UIButton *bmwBtn;
    IBOutlet UIButton *chargingBtn;
    IBOutlet UIButton *batteriesBtn;
    IBOutlet UIButton *rangeBtn;
    IBOutlet UIImageView *titleImage;
    ActiveEPopupView *currentPopup;
}

- (void)on;
- (void)off;

- (IBAction)bmwClick:(id)sender;
- (IBAction)electricClick:(id)sender;
- (IBAction)optionClick:(id)sender;

@end
