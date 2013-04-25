//
//  LifestyleViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "LifestyleViewController.h"
#import "AudioManager.h"

@implementation LifestyleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    // slider
    isDaySelected = FALSE;
    //btnDayYear.enabled = FALSE;
    lblSubtitle.font = [UIFont fontWithName:@"Tungsten-Medium" size:26];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderOpened) name:@"SliderOpened" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderClosed) name:@"SliderClosed" object:nil];
    //[self loadSlider];
}


- (IBAction)showEVVideo:(id)sender
{
    NSString *movieName = @"Lifestyle_Video";
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"True", @"hasControls", @"True", @"fadeIn", @"True", @"fadeOut", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
}


- (IBAction)showPioneersVideo:(id)sender
{
    NSString *movieName = @"LifeStyle_SM";
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"True", @"hasControls", @"True", @"fadeIn", @"True", @"fadeOut", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
}


- (IBAction)questionClick:(id)sender
{
    NSLog(@"QUESTION");
}


#pragma mark - slider methods

- (void)loadSlider
{
    dsDialSlider = [DSSliderController sharedSlider];
    dsDialSlider.view.frame = CGRectMake(210, 461, 592, 223);
    [self.view addSubview:dsDialSlider.view];
    
    [dsDialSlider initClosedState:FALSE];
    if ([dsDialSlider isDay]) [dsDialSlider toggleDayYear];
}


- (IBAction)dayYearButtonSelected:(id)sender
{
    if (isDaySelected) {
        isDaySelected = FALSE;
        [btnDayYear setBackgroundImage:[UIImage imageNamed:@"dayYearSel"] forState:UIControlStateNormal];
    } else {
        isDaySelected = TRUE;
        [btnDayYear setBackgroundImage:[UIImage imageNamed:@"daySelYear"] forState:UIControlStateNormal];
    }
    
    [dsDialSlider toggleDayYear];
    [self updateEnvironmentLabel];
}


- (IBAction)helpButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick2];
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"lifestyle", @"section", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
}


// calculate impact and update lbl
- (void)updateEnvironmentLabel
{
    float flMiles = [dsDialSlider flConvertedMiles];
    lblSubtitle.text = [NSString stringWithFormat:@"Avoid %.0f trips to the gas pump per year.", (flMiles/22)/16];
}


- (void)sliderOpened
{
    [self updateEnvironmentLabel];
    
    lblSubtitle.hidden = YES;
    imgViewMainTitle.hidden = NO;
    btnHelp.hidden = NO;
}


- (void)sliderClosed
{
    [self updateEnvironmentLabel];
    lblSubtitle.hidden = NO;
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
