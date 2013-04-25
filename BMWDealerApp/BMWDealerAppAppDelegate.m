//
//  BMWDealerAppAppDelegate.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "BMWDealerAppAppDelegate.h"
#import "DSTabBarViewController.h"
#import "IntroViewController.h"
#import "DSSliderController.h"

@implementation BMWDealerAppAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;
@synthesize introViewController;
@synthesize helpViewController;
@synthesize currentScreenType;
@synthesize lastScreenType;
@synthesize isVideoPlaying;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    //self.window.rootViewController = self.tabBarController;
    [self displayViewController:kIntroScreen];
    [self startTimer];
    [self.window makeKeyAndVisible];
    
    // Set notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMovie:) name:@"displayMovie" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"IdleTimerReset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMovieModal) name:@"PresentMovieModal" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoComplete) name:@"videoComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHelp:) name:@"showHelp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHelp:) name:@"hideHelp" object:nil];
    
    isVideoPlaying = NO;
    
    return YES;
}


- (void)displayViewController:(int)intScreenId
{
    lastScreenType = currentScreenType;
    currentScreenType = intScreenId;
    
	switch (currentScreenType)
	{
            
		case kIntroScreen:
            if (!introViewController) {
                introViewController = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
            }
            self.window.rootViewController = introViewController;
            [introViewController resetIntroView];
            
            // reset slider
            [[DSSliderController sharedSlider] resetSlider];
            
			break;
            
        case kTabBarScreen:
			//if (!tabBarController) {
                tabBarController = [[DSTabBarViewController alloc] initWithNibName:@"DSTabBarViewController" bundle:nil];
            //}
            self.window.rootViewController = tabBarController;
			break;
			
		default:
			break;
	}
}


- (void)displayMovie:(NSNotification *)notification
{
    NSString *movieName = [[notification userInfo] objectForKey:@"movieName"];
    NSString *hasControls = [[notification userInfo] objectForKey:@"hasControls"];
    NSString *fadeIn = [[notification userInfo] objectForKey:@"fadeIn"];
    NSString *fadeOut = [[notification userInfo] objectForKey:@"fadeOut"];
    [self loadMovie:movieName showControls:hasControls fadeIn:fadeIn fadeOut:fadeOut];
}


- (void)loadMovie:(NSString *)movieName showControls:(NSString*)hasControls fadeIn:(NSString *)doesFadeIn fadeOut:(NSString *)doesFadeOut
{
    isVideoPlaying = YES;
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:movieName ofType:@"mp4"];

    // Create custom movie player 
    moviePlayer = [[CustomMoviePlayerViewController alloc] initWithNibName:@"CustomMoviePlayerView" bundle:nil];
    [moviePlayer playMovie:[NSURL fileURLWithPath:moviePath] withControls:hasControls fadeIn:doesFadeIn fadeOut:doesFadeOut];
	//moviePlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //moviePlayer.view.hidden = TRUE;
    
    // Show the movie player as modal
    //[self.window.rootViewController presentModalViewController:moviePlayer animated:NO];
    [self.window.rootViewController.view addSubview:moviePlayer.view];
    //self.window.rootViewController = moviePlayer;
}


- (void)videoComplete
{
    isVideoPlaying = NO;
}


-(void)presentMovieModal
{
    //[self.window.rootViewController presentModalViewController:moviePlayer animated:NO];
    //moviePlayer.view.hidden = FALSE;
}


- (void)showHelp:(NSNotification *)notification
{
    NSString *section = [[notification userInfo] objectForKey:@"section"];
    
    // Help screen
    helpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]];
    [helpViewController displayHelpForSection:section];
    [self.window.rootViewController.view addSubview:helpViewController.view];
}


- (void)hideHelp:(NSNotification *)notification
{
    [helpViewController.view removeFromSuperview];
    helpViewController = nil;
}


-(void) startTimer
{
	[self stopTimer];
	idleTimer = [NSTimer scheduledTimerWithTimeInterval:600
                                                 target:self 
                                               selector:@selector(loadIntroScreen) 
                                               userInfo:nil 
                                                repeats:NO];
}


-(void) stopTimer
{
	if (idleTimer != nil ) {
		[idleTimer invalidate];
		idleTimer = nil;
	}
}


- (void)loadIntroScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerPlaybackDidFinishNotification object:self];
    [self displayViewController:kIntroScreen];
    [self startTimer];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [introViewController release];
    [helpViewController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
