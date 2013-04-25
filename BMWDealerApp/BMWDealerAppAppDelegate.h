//
//  BMWDealerAppAppDelegate.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomMoviePlayerViewController.h"
#import "HelpViewController.h"

@class DSTabBarViewController;
@class IntroViewController;

typedef enum screenTypeTag
{
	kIntroScreen,
    kTabBarScreen
} ScreenType;

@interface BMWDealerAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DSTabBarViewController *tabBarController;
    IntroViewController *introViewController;
    HelpViewController *helpViewController;
    
    int currentScreenType;
    int lastScreenType;
    
    BOOL isVideoPlaying;
    
    NSTimer *idleTimer;
    
    CustomMoviePlayerViewController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DSTabBarViewController *tabBarController;
@property (nonatomic, retain) IBOutlet IntroViewController *introViewController;
@property (nonatomic, retain) HelpViewController *helpViewController;
@property int currentScreenType;
@property int lastScreenType;
@property BOOL isVideoPlaying;

- (void)loadMovie:(NSString *)movieName showControls:(NSString*)hasControls fadeIn:(NSString *)doesFadeIn fadeOut:(NSString *)doesFadeOut;
- (void)displayViewController:(int)intScreenId;
- (void)startTimer;
- (void)stopTimer;
- (void)loadIntroScreen;
- (void)presentMovieModal;

@end
