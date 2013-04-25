//
//  IntroViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/26/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum introTypeTag
{
    kStartOverIntro,
	kEVIntro,
    kActiveEIntro,
    kReadyIntro
} IntroViewType;

@interface IntroViewController : UIViewController <UIGestureRecognizerDelegate> {
    
    IBOutlet UIButton *btnIntro;
    IBOutlet UIImageView *imgViewLogo;
    IBOutlet UIButton *btnElectronaut;
    IBOutlet UIImageView * backgroundImageView;
    
    int intCurrentBtnPress;
    BOOL isClickable;
}

- (IBAction)introButtonSelected:(id)sender;
- (IBAction)helpButtonSelected:(id)sender;
- (void)resetIntroView;

@end
