//
//  IntroViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/26/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "IntroViewController.h"
#import "BMWDealerAppAppDelegate.h"
#import "EVsViewController.h"
#import "ActiveEViewController.h"
#import "ReadyViewController.h"
#import "DSTabBarViewController.h"
#import "AudioManager.h"

@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isClickable = YES;
    
    // Set notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(introAnimationFinished) name:@"introViewControllerSetBackgroundImage" object:nil];

	[imgViewLogo removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)introAnimationFinished
{
    isClickable = YES;
    
    switch (intCurrentBtnPress) 
    {
        case kStartOverIntro:
            backgroundImageView.image = [UIImage imageNamed:@"ATF_intro.jpg"];
            break;
            
        case kEVIntro:
            backgroundImageView.image = [UIImage imageNamed:@"ActiveE_BG.jpg"];
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(goToEvController) userInfo:nil repeats:NO];
            break;
            
        case kActiveEIntro:
            backgroundImageView.image = [UIImage imageNamed:@"activee-bg.png"];
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(goToActiveEController) userInfo:nil repeats:NO];
            break;
            
        case kReadyIntro:
            backgroundImageView.image = [UIImage imageNamed:@""];
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(goToReadyController) userInfo:nil repeats:NO];
            break;
            
        default:
            break;
    }
}


- (void)goToEvController
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    
    [applicationDelegate displayViewController:kTabBarScreen];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayEVController" object:nil userInfo:nil];
    
    [self resetIntroView];
}


- (void)goToActiveEController
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    
    [applicationDelegate displayViewController:kTabBarScreen];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayActiveEController" object:nil userInfo:nil];
    
    [self resetIntroView];
}


- (void)goToReadyController
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
    
    [applicationDelegate displayViewController:kTabBarScreen];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayReadyController" object:nil userInfo:nil];
    
    [self resetIntroView];
}


- (void)resetIntroView
{
    btnIntro.hidden = NO;
    imgViewLogo.hidden = YES;
}


#pragma mark - Touches

- (IBAction)introButtonSelected:(id)sender
{
    if (isClickable) {
        isClickable = NO;
        intCurrentBtnPress = kStartOverIntro;
        backgroundImageView.image = [UIImage imageNamed:@"introBG.jpg"];
        btnIntro.hidden = YES;
        imgViewLogo.hidden = NO;
        
        NSString *movieName = @"ATF_Intro_Scan";
        NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"False", @"hasControls", @"True", @"fadeIn", @"False", @"fadeOut", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
        [[AudioManager sharedAudioManager] playScanFinger];
    }
}


- (IBAction)helpButtonSelected:(id)sender
{
    if (isClickable) {
        [[AudioManager sharedAudioManager] playClick2];
        NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"intro", @"section", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
    }
}


- (IBAction)evsButtonSelected:(id)sender
{
    if (isClickable) {
        isClickable = NO;
        [[AudioManager sharedAudioManager] playClick3];
        intCurrentBtnPress = kEVIntro;
        
        NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"3carsMov1", @"movieName", @"False", @"hasControls", @"False", @"fadeIn", @"False", @"fadeOut", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
    }
}


- (IBAction)activeEButtonSelected:(id)sender
{
    if (isClickable) {
        isClickable = NO;
        [[AudioManager sharedAudioManager] playClick3];
        intCurrentBtnPress = kActiveEIntro;
        
        NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"3carsMov2", @"movieName", @"False", @"hasControls", @"False", @"fadeIn", @"False", @"fadeOut", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
    }
}


- (IBAction)readyButtonSelected:(id)sender
{
    if (isClickable) {
        isClickable = NO;
        [[AudioManager sharedAudioManager] playClick3];
        intCurrentBtnPress = kReadyIntro;
        
        NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"3carsMov3", @"movieName", @"False", @"hasControls", @"False", @"fadeIn", @"False", @"fadeOut", nil] autorelease];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer 
{
    BMWDealerAppAppDelegate *applicationDelegate = [[UIApplication sharedApplication] delegate];
	[applicationDelegate displayViewController:kTabBarScreen];
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
}

@end
