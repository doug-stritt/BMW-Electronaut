//
//  DSDialSlider.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/15/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "DSDialSlider.h"

static DSDialSlider *_sharedSlider = nil;

@implementation DSDialSlider

@synthesize intCurrentMiles,flCurrentMiles,flConvertedMiles,isDay;


# pragma mark - Singleton methods

+ (DSDialSlider*)sharedSlider
{
    if (_sharedSlider == nil) {
        _sharedSlider = [[super allocWithZone:NULL] initWithNibName:@"DSDialSlider" bundle:nil];
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
    
    isDay = FALSE;
    
    lblClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    lblIDriveClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    lblMilesPerClosed.font = [UIFont fontWithName:@"Tungsten-Medium" size:24];
    lblDial1Miles1.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial1Miles2.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial1Miles3.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial1Miles4.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial2Miles1.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial2Miles2.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial2Miles3.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    lblDial2Miles4.font = [UIFont fontWithName:@"Tungsten-Medium" size:22];
    
    arrTracks = [[NSMutableArray alloc] init];
    for (int i=1; i<5; i++) {
        [arrTracks addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Slider_Track_Dashes_0%i",i]]];
    }
    
    // init dials
    intDial1StartCount = 10;
    [self setDial1];
    
    intDial2StartCount = 14;
    [self setDial2];
    
    [self findClosestValue];
    flCurrentMiles = (float)intCurrentMiles;
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


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SliderOpened" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    
    // record location
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:self.view];
    
    viewClosed.hidden = YES;
    [self startTimer:.1];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // record location
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:self.view];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    viewClosed.hidden = NO;
    [self stopTimer];
    [self findClosestValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SliderClosed" object:self];
}


# pragma mark - timer 

-(void) startTimer:(float)flTimeInterval
{
	[self stopTimer];
	
	timerMoveDial = [NSTimer scheduledTimerWithTimeInterval:flTimeInterval
                                                     target:self 
                                                   selector:@selector(moveDial) 
                                                   userInfo:nil 
                                                    repeats:YES];
}


-(void) stopTimer
{
	if (timerMoveDial != nil ) {
		[timerMoveDial invalidate];
		timerMoveDial = nil;
	}
}


- (void)moveDial
{
    // touch right/move left
    if (touchLocation.x > 200)
    {
        CGRect frame = viewDial.frame;
        CGRect frame2 = viewDial2.frame;
        
        if (frame.origin.x < 29) {
            frame.origin.x = frame2.origin.x + frame2.size.width;
            viewDial.frame = frame;
            
            intDial1StartCount = intDial1StartCount+8;
            [self setDialToggle1];
        } else if (frame2.origin.x < 29) {
            frame2.origin.x = frame.origin.x + frame.size.width;
            viewDial2.frame = frame2;
            
            intDial2StartCount = intDial2StartCount+8;
            [self setDialToggle2];
        }
        
        if (!(intDial1StartCount >= 100 && frame.origin.x > 168))
        {
            if (!(intDial2StartCount >= 100 && frame2.origin.x > 168))
            {
                frame.origin.x = frame.origin.x - 5;
                viewDial.frame = frame;

                frame2.origin.x = frame2.origin.x - 5;
                viewDial2.frame = frame2;
            }
        }
        
        // track animation
        if (intTrackCount == [arrTracks count]-1) {
            intTrackCount = 0;
        } else {
            intTrackCount++;
        }
        imgViewTracksLeft.image = [arrTracks objectAtIndex:intTrackCount];
        imgViewTracksRight.image = [arrTracks objectAtIndex:intTrackCount];
        
        // reset the timer
        if (touchLocation.x > 240)
        {
            [self startTimer:.05];
        } else 
        {
            [self startTimer:.1];
        }
    }
    
    // touch left/move right
    if (touchLocation.x < 160) 
    {
        CGRect frame = viewDial.frame;
        CGRect frame2 = viewDial2.frame;
        
        if (frame.origin.x > 230) {
            frame.origin.x = frame2.origin.x - frame2.size.width;
            viewDial.frame = frame;
        
            intDial1StartCount = intDial1StartCount-8;
            [self setDialToggle1];
            
        } else if (frame2.origin.x > 230) {
            frame2.origin.x = frame.origin.x - frame.size.width;
            viewDial2.frame = frame2;
            
            intDial2StartCount = intDial2StartCount-8;
            [self setDialToggle2];
        }
 
        if (!(intDial1StartCount <= 0 && frame.origin.x > 168))
        {
            if (!(intDial2StartCount <= 0 && frame2.origin.x > 168))
            {
                frame.origin.x = frame.origin.x + 5;
                viewDial.frame = frame;
                
                frame2.origin.x = frame2.origin.x + 5;
                viewDial2.frame = frame2;
            }
        }
        
        // track animation
        if (intTrackCount == 0) {
            intTrackCount = [arrTracks count]-1;
        } else {
            intTrackCount--;
        }
        imgViewTracksLeft.image = [arrTracks objectAtIndex:intTrackCount];
        imgViewTracksRight.image = [arrTracks objectAtIndex:intTrackCount];
 
        // reset the timer
        if (touchLocation.x < 120)
        {
            [self startTimer:.05];
        } else 
        {
            [self startTimer:.1];
        }
    }
}


- (void)setDial1
{
    if (isDay) {
        lblDial1Miles1.text = [NSString stringWithFormat:@"%i", intDial1StartCount];
        lblDial1Miles2.text = [NSString stringWithFormat:@"%i", intDial1StartCount+1];
        lblDial1Miles3.text = [NSString stringWithFormat:@"%i", intDial1StartCount+2];
        lblDial1Miles4.text = [NSString stringWithFormat:@"%i", intDial1StartCount+3];
    } else {
        lblDial1Miles1.text = [NSString stringWithFormat:@"%iK", intDial1StartCount];
        lblDial1Miles2.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+1];
        lblDial1Miles3.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+2];
        lblDial1Miles4.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+3];
    }
}


- (void)setDial2
{    
    if (intDial2StartCount > 0) {
        if (isDay) {
            lblDial2Miles1.text = [NSString stringWithFormat:@"%i", intDial2StartCount];
            lblDial2Miles2.text = [NSString stringWithFormat:@"%i", intDial2StartCount+1];
            lblDial2Miles3.text = [NSString stringWithFormat:@"%i", intDial2StartCount+2];
            lblDial2Miles4.text = [NSString stringWithFormat:@"%i", intDial2StartCount+3];
        } else {
            lblDial2Miles1.text = [NSString stringWithFormat:@"%iK", intDial2StartCount];
            lblDial2Miles2.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+1];
            lblDial2Miles3.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+2];
            lblDial2Miles4.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+3];
        }
    } else {
        lblDial2Miles1.text = @"";
        lblDial2Miles2.text = @"";
        lblDial2Miles3.text = @"";
        lblDial2Miles4.text = @"";
    }
}


- (void)setDialToggle1
{
    NSLog(@"intDial1StartCount %i", intDial1StartCount);
    if (isDay) {
        if (intDial1StartCount > -1) {
            lblDial1Miles1.text = [NSString stringWithFormat:@"%i", intDial1StartCount];
        } else {
            lblDial1Miles1.text = @"";
        }
        
        if (intDial1StartCount > -2) {
            lblDial1Miles2.text = [NSString stringWithFormat:@"%i", intDial1StartCount+1];
        } else {
            lblDial1Miles2.text = @"";
        }
        
        if (intDial1StartCount > -3) {
            lblDial1Miles3.text = [NSString stringWithFormat:@"%i", intDial1StartCount+2];
        } else {
            lblDial1Miles3.text = @"";
        }
        
        if (intDial1StartCount > -4) {
            lblDial1Miles4.text = [NSString stringWithFormat:@"%i", intDial1StartCount+3];
        } else {
            lblDial1Miles4.text = @"";
        }
    } else {
        if (intDial1StartCount > -1) {
            lblDial1Miles1.text = [NSString stringWithFormat:@"%iK", intDial1StartCount];
        } else {
            lblDial1Miles1.text = @"";
        }
        
        if (intDial1StartCount > -2) {
            lblDial1Miles2.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+1];
        } else {
            lblDial1Miles2.text = @"";
        }
        
        if (intDial1StartCount > -3) {
            lblDial1Miles3.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+2];
        } else {
            lblDial1Miles3.text = @"";
        }
        
        if (intDial1StartCount > -4) {
            lblDial1Miles4.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+3];
        } else {
            lblDial1Miles4.text = @"";
        }
    }
}


- (void)setDialToggle2
{    
    NSLog(@"intDial2StartCount %i", intDial2StartCount);
    if (isDay) {
        if (intDial2StartCount > -1) {
            lblDial2Miles1.text = [NSString stringWithFormat:@"%i", intDial2StartCount];
        } else {
            lblDial2Miles1.text = @"";
        }
        
        if (intDial2StartCount > -2) {
            lblDial2Miles2.text = [NSString stringWithFormat:@"%i", intDial2StartCount+1];
        } else {
            lblDial2Miles2.text = @"";
        }
        
        if (intDial2StartCount > -3) {
            lblDial2Miles3.text = [NSString stringWithFormat:@"%i", intDial2StartCount+2];
        } else {
            lblDial2Miles3.text = @"";
        }
        
        if (intDial2StartCount > -4) {
            lblDial2Miles4.text = [NSString stringWithFormat:@"%i", intDial2StartCount+3];
        } else {
            lblDial2Miles4.text = @"";
        }
    } else {
        if (intDial2StartCount > -1) {
            lblDial2Miles1.text = [NSString stringWithFormat:@"%iK", intDial2StartCount];
        } else {
            lblDial2Miles1.text = @"";
        }
        
        if (intDial2StartCount > -2) {
            lblDial2Miles2.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+1];
        } else {
            lblDial2Miles2.text = @"";
        }
        
        if (intDial2StartCount > -3) {
            lblDial2Miles3.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+2];
        } else {
            lblDial2Miles3.text = @"";
        }
        
        if (intDial2StartCount > -4) {
            lblDial2Miles4.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+3];
        } else {
            lblDial2Miles4.text = @"";
        }
    }
}


- (void)findClosestValue
{
    CGRect frameDial1 = viewDial.frame;
    CGRect frameDial2 = viewDial2.frame;
    
    float flDial1Middle = frameDial1.origin.x + frameDial1.size.width/2;
    float flDial2Middle = frameDial2.origin.x + frameDial2.size.width/2;
    
    float flDial1Compare = fabs(180 - flDial1Middle);
    float flDial2Compare = fabs(180 - flDial2Middle);

    if (flDial1Compare < flDial2Compare) {
        CGRect frameLbl1 = lblDial1Miles1.frame;
        CGRect frameLbl2 = lblDial1Miles2.frame;
        CGRect frameLbl3 = lblDial1Miles3.frame;
        CGRect frameLbl4 = lblDial1Miles4.frame;
        
        float flLabel1Compare = fabs(180 - frameDial1.origin.x - (frameLbl1.origin.x + frameLbl1.size.width/2));
        float flLabel2Compare = fabs(180 - frameDial1.origin.x - (frameLbl2.origin.x + frameLbl2.size.width/2));
        float flLabel3Compare = fabs(180 - frameDial1.origin.x - (frameLbl3.origin.x + frameLbl3.size.width/2));
        float flLabel4Compare = fabs(180 - frameDial1.origin.x - (frameLbl4.origin.x + frameLbl4.size.width/2));
        
        
        if (flLabel2Compare < flLabel3Compare) {
            if (flLabel1Compare < flLabel2Compare) {
                if (isDay) {
                    lblClosed.text = [NSString stringWithFormat:@"%i", intDial1StartCount];
                } else {
                    lblClosed.text = [NSString stringWithFormat:@"%iK", intDial1StartCount];
                }
                intCurrentMiles = intDial1StartCount;
                
            } else {
                if (isDay) {
                    lblClosed.text = [NSString stringWithFormat:@"%i", intDial1StartCount+1];
                } else {
                    lblClosed.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+1];
                }
                intCurrentMiles = intDial1StartCount+1;
            }
        } else if (flLabel3Compare < flLabel4Compare) {
            if (isDay) {
                lblClosed.text = [NSString stringWithFormat:@"%i", intDial1StartCount+2];
            } else {
                lblClosed.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+2];
            }
            intCurrentMiles = intDial1StartCount+2;
        } else {
            if (isDay) {
                lblClosed.text = [NSString stringWithFormat:@"%i", intDial1StartCount+3];
            } else {
                lblClosed.text = [NSString stringWithFormat:@"%iK", intDial1StartCount+3];
            }
            intCurrentMiles = intDial1StartCount+3;
        }
    } else {
        CGRect frameLbl1 = lblDial2Miles1.frame;
        CGRect frameLbl2 = lblDial2Miles2.frame;
        CGRect frameLbl3 = lblDial2Miles3.frame;
        CGRect frameLbl4 = lblDial2Miles4.frame;
        
        float flLabel1Compare = fabs(180 - frameDial2.origin.x - (frameLbl1.origin.x + frameLbl1.size.width/2));
        float flLabel2Compare = fabs(180 - frameDial2.origin.x - (frameLbl2.origin.x + frameLbl2.size.width/2));
        float flLabel3Compare = fabs(180 - frameDial2.origin.x - (frameLbl3.origin.x + frameLbl3.size.width/2));
        float flLabel4Compare = fabs(180 - frameDial2.origin.x - (frameLbl4.origin.x + frameLbl4.size.width/2));
        
        
        if (flLabel2Compare < flLabel3Compare) {
            if (flLabel1Compare < flLabel2Compare) {
                if (isDay) {
                    lblClosed.text = [NSString stringWithFormat:@"%i", intDial2StartCount];
                } else {
                    lblClosed.text = [NSString stringWithFormat:@"%iK", intDial2StartCount];
                }
                intCurrentMiles = intDial2StartCount;
            } else {
                if (isDay) {
                    lblClosed.text = [NSString stringWithFormat:@"%i", intDial2StartCount+1];
                } else {
                    lblClosed.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+1];
                }
                intCurrentMiles = intDial2StartCount+1;
            }
        } else if (flLabel3Compare < flLabel4Compare) {
            if (isDay) {
                lblClosed.text = [NSString stringWithFormat:@"%i", intDial2StartCount+2];
            } else {
                lblClosed.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+2];
            }
            intCurrentMiles = intDial2StartCount+2;
        } else {
            if (isDay) {
                lblClosed.text = [NSString stringWithFormat:@"%i", intDial2StartCount+3];
            } else {
                lblClosed.text = [NSString stringWithFormat:@"%iK", intDial2StartCount+3];
            }
            intCurrentMiles = intDial2StartCount+3;
        }
    }
    
    flCurrentMiles = (float)intCurrentMiles;
    
    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
}


- (void)toggleDayYear
{
    CGRect frameDial1 = viewDial.frame;
    frameDial1.origin.x = 120;
    viewDial.frame = frameDial1;
    
    CGRect frameDial2 = viewDial2.frame;
    frameDial2.origin.x = 220;
    viewDial2.frame = frameDial2;
    
    if (isDay) {
        // year
        isDay = FALSE;
        flCurrentMiles = (flCurrentMiles * 365)/1000;
        intCurrentMiles = (int)flCurrentMiles;
        intDial1StartCount = intCurrentMiles - 2;
        intDial2StartCount = intCurrentMiles + 2;
        lblClosed.text = [NSString stringWithFormat:@"%iK", intCurrentMiles];
        lblMilesPer.text = @"MILES PER YEAR";
    } else {
        // day
        isDay = TRUE;
        flCurrentMiles = (flCurrentMiles * 1000)/365;
        intCurrentMiles = (int)flCurrentMiles;
        intDial1StartCount = intCurrentMiles - 2;
        intDial2StartCount = intCurrentMiles + 2;
        lblClosed.text = [NSString stringWithFormat:@"%i", intCurrentMiles];
        lblMilesPer.text = @"MILES PER DAY";
    }
    
    [self setDialToggle1];
    [self setDialToggle2];
    
    if (isDay) {
        flConvertedMiles = (float)intCurrentMiles;
    } else {
        flConvertedMiles = (float)intCurrentMiles * 1000;
    }
}

@end
