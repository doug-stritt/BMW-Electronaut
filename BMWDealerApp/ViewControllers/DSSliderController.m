//
//  DSSliderController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 10/18/11.
//  Copyright (c) 2011 Spies & Assassins. All rights reserved.
//

#import "DSSliderController.h"
#import "AudioManager.h"

static DSSliderController *_sharedSlider = nil;

#define LINE_PIXEL_DISTANCE 38

@implementation DSSliderController

@synthesize intCurrentMiles,isDay,flConvertedMiles,isEVIntro,flCurrentMiles;

# pragma mark - Singleton methods

+ (DSSliderController*)sharedSlider
{
    if (_sharedSlider == nil) {
        _sharedSlider = [[super allocWithZone:NULL] initWithNibName:@"DSSliderController" bundle:nil];
    }
    return _sharedSlider;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedSlider];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    lblMiles.font = [UIFont fontWithName:@"Tungsten-Medium" size:26];
    lblBasedClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    lblMilesPerClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    lblClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    intCurrentMiles = 12;
    flCurrentMiles = 12;
    flConvertedMiles = 12000;
    isEVIntro = TRUE;
    
    // add lines
    for (int i=-418; i<4400; i=i+418) {
        UIImageView *imgViewLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lines400.png"]];
        imgViewLines.frame = CGRectMake(i, 0, imgViewLines.frame.size.width, imgViewLines.frame.size.height);
        [scrViewMiles addSubview:imgViewLines];
        [imgViewLines release];
    }
    
	scrViewMiles.contentSize = CGSizeMake(LINE_PIXEL_DISTANCE*110, scrViewMiles.frame.size.height);
    scrViewMiles.contentOffset = CGPointMake(LINE_PIXEL_DISTANCE*intCurrentMiles, scrViewMiles.contentOffset.y);
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)minusButtonPressed:(id)sender
{
    if (timerMoveDial != nil ) {
        [self stopTimer];
        [self snapScrollView];
	} else {
        timerMoveDial = [NSTimer scheduledTimerWithTimeInterval:.1
                                                         target:self 
                                                       selector:@selector(moveDialMinus) 
                                                       userInfo:nil 
                                                        repeats:YES];
    }
}


- (IBAction)plusButtonPressed:(id)sender
{
    if (timerMoveDial != nil ) {
        [self stopTimer];
        [self snapScrollView];
	} else {
        timerMoveDial = [NSTimer scheduledTimerWithTimeInterval:.1
                                                         target:self 
                                                       selector:@selector(moveDialPlus) 
                                                       userInfo:nil 
                                                        repeats:YES];
    }
}


- (IBAction)buttonReleased:(id)sender
{
    [self stopTimer];
    [self snapScrollView];
}


- (void)toggleDayYear
{
    if (isDay) {
        // year
        isDay = FALSE;
        flCurrentMiles = (flCurrentMiles * 365)/1000;
        
        if (flCurrentMiles-(int)flCurrentMiles < .5) {
            intCurrentMiles = (int)flCurrentMiles;
        } else { 
            intCurrentMiles = (int)flCurrentMiles+1;
        }
        
        scrViewMiles.contentOffset = CGPointMake(intCurrentMiles*LINE_PIXEL_DISTANCE, 0);
        lblClosed.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
        lblMilesPerClosed.text = @"MILES ANNUALLY";
    } else {
        // day
        isDay = TRUE;
        flCurrentMiles = (flCurrentMiles * 1000)/365;
        
        if (flCurrentMiles < 100)
        {
            if (flCurrentMiles-(int)flCurrentMiles < .5) {
                intCurrentMiles = (int)flCurrentMiles;
            } else { 
                intCurrentMiles = (int)flCurrentMiles+1;
            }
        } else {
            intCurrentMiles = flCurrentMiles = 99;
        }
        
        scrViewMiles.contentOffset = CGPointMake(intCurrentMiles*LINE_PIXEL_DISTANCE, 0);
        lblClosed.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
        lblMilesPerClosed.text = @"MILES DAILY";
    }
    
    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
}


- (void)initClosedState:(BOOL)isOpen
{
    isEVIntro = isOpen;
    if (isEVIntro) {
        viewClosed.hidden = YES;
        viewSlider.hidden = NO;
        [self stopCloseTimer];
    } else {
        viewClosed.hidden = NO;
        viewSlider.hidden = YES;
        [self startCloseTimer];
    }
    
    if (isDay || intCurrentMiles <= 0) {
        // day
        lblMiles.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
        lblClosed.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
        lblMilesPerClosed.text = @"MILES DAILY";
    } else {
        // year
        lblMiles.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
        lblClosed.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
        lblMilesPerClosed.text = @"MILES ANNUALLY";
    }
    
    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
}


# pragma mark - timer 


-(void) stopTimer
{
	if (timerMoveDial != nil ) {
		[timerMoveDial invalidate];
		timerMoveDial = nil;
	}
}


- (void)moveDialMinus
{
    if (!isEVIntro) [self startCloseTimer];
    scrViewMiles.contentOffset = CGPointMake(scrViewMiles.contentOffset.x-10, scrViewMiles.contentOffset.y);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSliderInfo" object:self];
}


- (void)moveDialPlus
{
    if (!isEVIntro) [self startCloseTimer];
    scrViewMiles.contentOffset = CGPointMake(scrViewMiles.contentOffset.x+10, scrViewMiles.contentOffset.y);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSliderInfo" object:self];
}


- (void)startCloseTimer
{
    [self stopCloseTimer];
    timerCloseDial = [NSTimer scheduledTimerWithTimeInterval:2
                                                     target:self 
                                                   selector:@selector(closeSlider) 
                                                   userInfo:nil 
                                                    repeats:NO];
}


-(void) stopCloseTimer
{
	if (timerCloseDial != nil) {
		[timerCloseDial invalidate];
		timerCloseDial = nil;
	}
}


- (void)closeSlider
{
    [self stopCloseTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SliderClosed" object:self];
    viewClosed.hidden = NO;
    viewSlider.hidden = YES;
}


- (void)resetSlider
{
    intCurrentMiles = 12;
    flCurrentMiles = 12;
}



#pragma - scroll view methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    if (!isEVIntro) [self startCloseTimer];
    float flMiles = scrollView.contentOffset.x/LINE_PIXEL_DISTANCE;
    if (intCurrentMiles != (int)flMiles) [[AudioManager sharedAudioManager] playTick];
    flCurrentMiles = flMiles;
    intCurrentMiles = (int)flMiles;

    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
    
    if (intCurrentMiles < 0) {
        [self stopTimer];
        lblMiles.text = @"0";
        lblClosed.text = @"0";
    } else if (isDay && intCurrentMiles >= 100) {
        [self stopTimer];
        [self snapScrollView];
    } else if (!isDay && intCurrentMiles >= 37) {
        [self stopTimer];
        [self snapScrollView];
    }  else {
        if (isDay || intCurrentMiles <= 0) {
            lblMiles.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
            lblClosed.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
        } else {
            lblMiles.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
            lblClosed.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSliderInfo" object:self];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [self snapScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self snapScrollView];
}


- (void)snapScrollView
{
    float flMiles = scrViewMiles.contentOffset.x/LINE_PIXEL_DISTANCE;
    if (isDay && intCurrentMiles >= 100) {
        intCurrentMiles = 99;
    } else if (!isDay && intCurrentMiles >= 37) {
        intCurrentMiles = 36;
    } else {
        intCurrentMiles = (int)flMiles;
    }
    
    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
    
    if ((flMiles-intCurrentMiles) < .5) {
        scrViewMiles.contentOffset = CGPointMake(LINE_PIXEL_DISTANCE*intCurrentMiles, scrViewMiles.contentOffset.y);
    } else {
        scrViewMiles.contentOffset = CGPointMake(LINE_PIXEL_DISTANCE*(intCurrentMiles+1), scrViewMiles.contentOffset.y);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSliderInfo" object:self];
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SliderOpened" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    
    if (!isEVIntro) {
        viewClosed.hidden = YES;
        viewSlider.hidden = NO;
        [self startCloseTimer];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
