//
//  DSTabBarViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVsViewController.h"
#import "ActiveEViewController.h"
#import "ReadyViewController.h"

typedef enum toolbarViewTypeTag
{
	kEVScreen,
    kActiveEScreen,
    kReadyScreen
} ToolbarViewType;

@interface DSTabBarViewController : UIViewController 
{
    EVsViewController *eVsViewController;
    ActiveEViewController *activeEViewController;
    ReadyViewController *readyViewController;
    
    IBOutlet UIImageView *imgViewIntro;
    IBOutlet UIImageView *logoView;
    IBOutlet UIImageView *glowBar;
    
    // toolbar
    IBOutlet UIView *viewToolbar;
    IBOutlet UIButton *btnStartOver;
    IBOutlet UIButton *btnEVs;
    IBOutlet UIButton *btnActiveE;
    IBOutlet UIButton *btnReady;
    int intCurrentToolbarViewType;
}

@property(nonatomic,retain) EVsViewController *eVsViewController;
@property(nonatomic,retain) ActiveEViewController *activeEViewController;
@property(nonatomic,retain) ReadyViewController *readyViewController;

- (IBAction)evsButtonSelected:(id)sender;
- (IBAction)activeEButtonSelected:(id)sender;
- (IBAction)readyButtonSelected:(id)sender;
- (IBAction)goToIntroButtonSelected:(id)sender;
- (void)removeCurrentView;

@end
