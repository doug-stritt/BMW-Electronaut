//
//  SavingsViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "SavingsViewController.h"
#import "AudioManager.h"

@implementation SavingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderOpened) name:@"SliderOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSavings) name:@"SliderClosed" object:nil];
    
    scoreboardView = [[ScoreboardViewController alloc] init];
    scoreboardView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [scoreboardBG addSubview:scoreboardView.view];
    [self updateSavings];
    
    // slider
    btnDayYear.hidden = YES;
    isDaySelected = NO;
    //[self loadSlider];
}


- (IBAction)showVideo:(id)sender
{
    NSString *movieName = @"Savings_SM";
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"True", @"hasControls", @"True", @"fadeIn", @"True", @"fadeOut", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
}


- (void)updateSavings
{
    float numGallons = dsDialSlider.flConvertedMiles / MILES_PER_GALLON;
    float savings = (AVG_GAS_PRICE * numGallons) - ((dsDialSlider.flConvertedMiles/RANGE_PER_CHARGE)*CHARGING_COST);
    [scoreboardView updateScoreboard:savings];
}


- (IBAction)helpButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick2];
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"savings", @"section", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
}


#pragma mark - slider methods

- (void)loadSlider
{
    dsDialSlider = [DSSliderController sharedSlider];
    dsDialSlider.view.frame = CGRectMake(210, 461, 592, 223);
    [self.view addSubview:dsDialSlider.view];
    
    [dsDialSlider initClosedState:FALSE];
    if ([dsDialSlider isDay] && !isDaySelected) [dsDialSlider toggleDayYear];
    
    [self updateSavings];
}


- (IBAction)dayYearButtonSelected:(id)sender
{
    if (isDaySelected) [btnDayYear setBackgroundImage:[UIImage imageNamed:@"dayYearSel"] forState:UIControlStateNormal];
    
    else [btnDayYear setBackgroundImage:[UIImage imageNamed:@"daySelYear"] forState:UIControlStateNormal];
    
    [dsDialSlider toggleDayYear];
    [self updateSavings];
    
    isDaySelected = !isDaySelected;
}


- (void)sliderOpened
{
    imgViewMainTitle.hidden = NO;
    btnHelp.hidden = NO;
    imgViewPersonalize.hidden = YES;
    lblTitle.text = @"Switch to an EV, and save on every drive.";
}


- (void)sliderClosed
{
    
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
