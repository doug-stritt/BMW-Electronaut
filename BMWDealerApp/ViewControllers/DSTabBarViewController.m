//
//  DSTabBarViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/25/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "DSTabBarViewController.h"
#import "IntroViewController.h"
#import "BMWDealerAppAppDelegate.h"
#import "AudioManager.h"

@implementation DSTabBarViewController

@synthesize eVsViewController,activeEViewController,readyViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init notifications
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayEVContoller) name:@"DisplayEVController" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayActiveEContoller) name:@"DisplayActiveEController" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayReadyContoller) name:@"DisplayReadyController" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showLogo) name:@"showLogo" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideLogo) name:@"hideLogo" object: nil];
    
    // init controllers
    eVsViewController = [[EVsViewController alloc] initWithNibName:@"EVsViewController" bundle:nil];
    activeEViewController = [[ActiveEViewController alloc] initWithNibName:@"ActiveEViewController" bundle:nil];
    readyViewController = [[ReadyViewController alloc] initWithNibName:@"ReadyViewController" bundle:nil];
    
    // button states
    [btnStartOver setBackgroundImage:[UIImage imageNamed:@"startOverSel"] forState:UIControlStateSelected];
    [btnStartOver setBackgroundImage:[UIImage imageNamed:@"startOverSel"] forState:UIControlStateHighlighted];
    [btnEVs setBackgroundImage:[UIImage imageNamed:@"EVsSel"] forState:UIControlStateSelected];
    [btnEVs setBackgroundImage:[UIImage imageNamed:@"EVsSel"] forState:UIControlStateHighlighted];
    [btnActiveE setBackgroundImage:[UIImage imageNamed:@"activeESel"] forState:UIControlStateSelected];
    [btnActiveE setBackgroundImage:[UIImage imageNamed:@"activeESel"] forState:UIControlStateHighlighted];
    [btnReady setBackgroundImage:[UIImage imageNamed:@"reserveSel"] forState:UIControlStateSelected];
    [btnReady setBackgroundImage:[UIImage imageNamed:@"reserveSel"] forState:UIControlStateHighlighted];
    
    // Add the new view controller's view
    intCurrentToolbarViewType = kEVScreen;
    [self.view insertSubview:eVsViewController.view belowSubview:viewToolbar];
    [eVsViewController loadSlider];
    [eVsViewController animateCarousel];
}


- (void)displayEVContoller
{
    // set button selection
    [btnStartOver setSelected:NO];
    [btnEVs setSelected:YES];
    [btnActiveE setSelected:NO];
    [btnReady setSelected:NO];
    
    [self removeCurrentView];
    intCurrentToolbarViewType = kEVScreen;
    [self.view insertSubview:eVsViewController.view belowSubview:viewToolbar];
    [eVsViewController loadSlider];
    [eVsViewController animateCarousel];
    
    // Glow bar animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [glowBar setFrame:CGRectMake(335, glowBar.frame.origin.y, glowBar.frame.size.width, glowBar.frame.size.height)];
    [UIView commitAnimations];
    
}


- (void)displayActiveEContoller
{
    // set button selection
    [btnStartOver setSelected:NO];
    [btnEVs setSelected:NO];
    [btnActiveE setSelected:YES];
    [btnReady setSelected:NO];
    
    [self removeCurrentView];
    intCurrentToolbarViewType = kActiveEScreen;
    if (activeEViewController) [activeEViewController release];
    activeEViewController = [[ActiveEViewController alloc] initWithNibName:@"ActiveEViewController" bundle:nil];
    [self.view insertSubview:activeEViewController.view belowSubview:viewToolbar];
    
    // Glow bar animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [glowBar setFrame:CGRectMake(498, glowBar.frame.origin.y, glowBar.frame.size.width, glowBar.frame.size.height)];
    [UIView commitAnimations];
}


- (void)displayReadyContoller
{
    // set button selection
    [btnStartOver setSelected:NO];
    [btnEVs setSelected:NO];
    [btnActiveE setSelected:NO];
    [btnReady setSelected:YES];
    
    [self removeCurrentView];
    intCurrentToolbarViewType = kReadyScreen;
    [self.view insertSubview:readyViewController.view belowSubview:viewToolbar];
    
    // Glow bar animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [glowBar setFrame:CGRectMake(662, glowBar.frame.origin.y, glowBar.frame.size.width, glowBar.frame.size.height)];
    [UIView commitAnimations];
}


- (void)showLogo
{
    logoView.hidden = NO;
}


- (void)hideLogo
{
    logoView.hidden = YES;
}


#pragma mark -
#pragma mark button methods

- (IBAction)evsButtonSelected:(id)sender
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    if (!applicationDelegate.isVideoPlaying) {
        [[AudioManager sharedAudioManager] playClick3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
        [eVsViewController displayIntroController];
        [self displayEVContoller];
    }
}


- (IBAction)activeEButtonSelected:(id)sender
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    if (!applicationDelegate.isVideoPlaying) {
        [[AudioManager sharedAudioManager] playClick3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
        [self displayActiveEContoller];
    }
}


- (IBAction)readyButtonSelected:(id)sender
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    if (!applicationDelegate.isVideoPlaying) {
        [[AudioManager sharedAudioManager] playClick3];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
        [self displayReadyContoller];
    }
}


- (IBAction)goToIntroButtonSelected:(id)sender
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    if (!applicationDelegate.isVideoPlaying) {
        [[AudioManager sharedAudioManager] playClick3];
        
        // Glow bar animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [glowBar setFrame:CGRectMake(175, glowBar.frame.origin.y, glowBar.frame.size.width, glowBar.frame.size.height)];
        [UIView commitAnimations];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayIntroController" object:nil userInfo:nil];
        
        [applicationDelegate displayViewController:kIntroScreen];
    }
}


- (void)removeCurrentView
{
    switch (intCurrentToolbarViewType) 
    {
        case kEVScreen:
            [eVsViewController.view removeFromSuperview];
            break;
        case kActiveEScreen:
            [activeEViewController.view removeFromSuperview];
            break;
        case kReadyScreen:
            [readyViewController.view removeFromSuperview];
            break;
            
        default:
            break;
    }
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [eVsViewController release];
    [activeEViewController release];
    [readyViewController release];
    [super dealloc];
}

@end

