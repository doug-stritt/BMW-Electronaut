//
//  EVsViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "EVsViewController.h"
#import "AudioManager.h"

@implementation EVsViewController
@synthesize environmentViewController,lifestyleViewController,rangeViewController,savingsViewController;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [lifestyleViewController release];
    [environmentViewController release];
    [savingsViewController release];
    [rangeViewController release];
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
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(displayIntroController) name:@"DisplayIntroController" object: nil];
    
    // init controllers
    environmentViewController = [[EnvironmentViewController alloc] initWithNibName:@"EnvironmentViewController" bundle:nil];
    lifestyleViewController = [[LifestyleViewController alloc] initWithNibName:@"LifestyleViewController" bundle:nil];
    rangeViewController = [[RangeViewController alloc] initWithNibName:@"RangeViewController" bundle:nil];
    savingsViewController = [[SavingsViewController alloc] initWithNibName:@"SavingsViewController" bundle:nil];
    
    // button states
    [btnLifestyle setBackgroundImage:[UIImage imageNamed:@"lifestyleTBSel"] forState:UIControlStateSelected];
    [btnLifestyle setBackgroundImage:[UIImage imageNamed:@"lifestyleTBSel"] forState:UIControlStateHighlighted];
    [btnEnvironment setBackgroundImage:[UIImage imageNamed:@"environmentTBSel"] forState:UIControlStateSelected];
    [btnEnvironment setBackgroundImage:[UIImage imageNamed:@"environmentTBSel"] forState:UIControlStateHighlighted];
    [btnSavings setBackgroundImage:[UIImage imageNamed:@"savingsTBSel"] forState:UIControlStateSelected];
    [btnSavings setBackgroundImage:[UIImage imageNamed:@"savingsTBSel"] forState:UIControlStateHighlighted];
    [btnRange setBackgroundImage:[UIImage imageNamed:@"rangeTBSel"] forState:UIControlStateSelected];
    [btnRange setBackgroundImage:[UIImage imageNamed:@"rangeTBSel"] forState:UIControlStateHighlighted];
    
    lblStartBy.font = [UIFont fontWithName:@"Tungsten-Medium" size:26];
    lblThenTap.font = [UIFont fontWithName:@"Tungsten-Medium" size:26];
    
    [self loadSlider];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)loadSlider
{
    //dsDialSlider = [[DSDialSlider alloc] initWithNibName:@"DSDialSlider" bundle:nil];
    dsSliderController = [DSSliderController sharedSlider];
    dsSliderController.view.frame = CGRectMake(218, 300, 592, 223);
    [viewCarousel addSubview:dsSliderController.view];
    
    [dsSliderController initClosedState:TRUE];
    if ([dsSliderController isDay]) [dsSliderController toggleDayYear];
}


- (void)animateCarousel
{
    CGRect frame = viewButtons.frame;
    frame.origin.x = -1024;
    viewButtons.frame = frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frameAnimation = viewButtons.frame;
    frameAnimation.origin.x = 0;
    viewButtons.frame = frameAnimation;
    
    [UIView commitAnimations];
}


- (void)displayIntroController
{
    viewCarousel.hidden = NO;
}


- (void)displayLifestyleController
{
    viewCarousel.hidden = YES;
    
    // set button selection
    [btnLifestyle setSelected:YES];
    [btnEnvironment setSelected:NO];
    [btnSavings setSelected:NO];
    [btnRange setSelected:NO];
    
    [self removeCurrentView];
    intEVCurrentToolbarViewType = kLifestyleScreen;
    [self.view insertSubview:lifestyleViewController.view belowSubview:viewToolbar];
    [lifestyleViewController loadSlider];
}


- (void)displayEnvironmentController
{
    viewCarousel.hidden = YES;
    
    // set button selection
    [btnLifestyle setSelected:NO];
    [btnEnvironment setSelected:YES];
    [btnSavings setSelected:NO];
    [btnRange setSelected:NO];
    
    [self removeCurrentView];
    intEVCurrentToolbarViewType = kEnvironmentScreen;
    [self.view insertSubview:environmentViewController.view belowSubview:viewToolbar];
    [environmentViewController loadSlider];
}


- (void)displaySavingsController
{
    viewCarousel.hidden = YES;
    
    // set button selection
    [btnLifestyle setSelected:NO];
    [btnEnvironment setSelected:NO];
    [btnSavings setSelected:YES];
    [btnRange setSelected:NO];
    
    [self removeCurrentView];
    intEVCurrentToolbarViewType = kSavingsScreen;
    [self.view insertSubview:savingsViewController.view belowSubview:viewToolbar];
    [savingsViewController loadSlider];
}


- (void)displayRangeController
{
    viewCarousel.hidden = YES;
    
    // set button selection
    [btnLifestyle setSelected:NO];
    [btnEnvironment setSelected:NO];
    [btnSavings setSelected:NO];
    [btnRange setSelected:YES];
    
    [self removeCurrentView];
    intEVCurrentToolbarViewType = kRangeScreen;
    [self.view insertSubview:rangeViewController.view belowSubview:viewToolbar];
    [rangeViewController loadSlider];
}


#pragma mark -
#pragma mark button methods

- (IBAction)lifestyleButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    [self displayLifestyleController];
    [dsSliderController initClosedState:FALSE];
}


- (IBAction)environmentButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    [self displayEnvironmentController];
    [dsSliderController initClosedState:FALSE];
}


- (IBAction)savingsButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    [self displaySavingsController];
    [dsSliderController initClosedState:FALSE];
}


- (IBAction)rangeButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    [self displayRangeController];
    [dsSliderController initClosedState:FALSE];
}


- (void)removeCurrentView
{
    switch (intEVCurrentToolbarViewType) 
    {
        case kLifestyleScreen:
            [lifestyleViewController.view removeFromSuperview];
            break;
        case kEnvironmentScreen:
            [environmentViewController.view removeFromSuperview];
            break;
        case kSavingsScreen:
            [savingsViewController.view removeFromSuperview];
            break;
        case kRangeScreen:
            [rangeViewController.view removeFromSuperview];
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

@end
