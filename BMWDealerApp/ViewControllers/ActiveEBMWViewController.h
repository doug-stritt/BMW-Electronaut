//
//  ActiveEBMWViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveEPopupView.h"


@interface ActiveEBMWViewController : UIViewController {
    IBOutlet UIButton *electricBtn;
    IBOutlet UIButton *bmwBtn;
    IBOutlet UIButton *performanceBtn;
    IBOutlet UIButton *comfortBtn;
    IBOutlet UIButton *designBtn;
    IBOutlet UIButton *efficientBtn;
    IBOutlet UIImageView *titleImage;
    ActiveEPopupView *currentPopup;
}

- (void)on;
- (void)off;

- (IBAction)bmwClick:(id)sender;
- (IBAction)electricClick:(id)sender;
- (IBAction)optionClick:(id)sender;

@end
