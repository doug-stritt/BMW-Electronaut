//
//  EnvironmentViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "EnvironmentViewController.h"
#import "AudioManager.h"

@implementation EnvironmentViewController

@synthesize pageViews=_pageViews, currentPageIndex=_currentPageIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderOpened) name:@"SliderOpened" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sliderClosed) name:@"SliderClosed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEnvironmentLabel) name:@"UpdateSliderInfo" object:nil];
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isDaySelected = FALSE;
    //btnDayYear.enabled = FALSE;
    lblSubtitle.font = [UIFont fontWithName:@"Tungsten-Medium" size:26];
    
    // init scroll view
    _pageLoopEnabled = YES;
    hasRotationHappened = FALSE;
    
    self.pageViews = [NSMutableArray array];
	// to save time and memory, we won't load the page views immediately
	NSUInteger numberOfPhysicalPages = (_pageLoopEnabled ? 3 * [self numberOfPages] : [self numberOfPages]);
	for (NSUInteger i = 0; i < numberOfPhysicalPages; ++i)
		[self.pageViews addObject:[NSNull null]];
    
    [self layoutPages];
	[self currentPageIndexDidChange];
	[self setPhysicalPageIndex:[self physicalPageForPage:_currentPageIndex]];
    //[self loadSlider];
    [self animateScrollView];
    
    if (hasSliderOpened) [self updateEnvironmentLabel]; 
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


-(void) animateScrollView
{
	CGRect frame = dsScrollView.frame;	
	frame.origin.x = 1000;
	dsScrollView.frame = frame;
	
	// animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.5];
	[UIView setAnimationDelegate:self];
    
    frame = dsScrollView.frame;	
    frame.origin.x = 255;
    dsScrollView.frame = frame;
	
	[UIView commitAnimations];
}


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
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"environment", @"section", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
}


// calculate impact and update lbl
- (void)updateEnvironmentLabel
{
    float flMiles = [dsDialSlider flConvertedMiles];
    float flLbsOfCO2 = flMiles * .78;
    //NSLog(@"flMiles %f", flMiles);
    NSNumberFormatter *formatterComma = [[[NSNumberFormatter alloc] init] autorelease];
    [formatterComma setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *strCO2 = [formatterComma stringFromNumber:[NSNumber numberWithFloat: (int)flLbsOfCO2]];
    NSString *strTree = [formatterComma stringFromNumber:[NSNumber numberWithFloat: (int)((flLbsOfCO2/2200)*5)]];
    NSString *strTV = [formatterComma stringFromNumber:[NSNumber numberWithInt: (int)(flLbsOfCO2/.58)]];
    NSString *strWasher = [formatterComma stringFromNumber:[NSNumber numberWithFloat: (int)(flLbsOfCO2/.73)]];
    NSString *strGarbage = [formatterComma stringFromNumber:[NSNumber numberWithInt: (int)(flLbsOfCO2*1.063/15)]];
    
    switch (_currentPageIndex) 
    {
        case kEnvironmentTree:
            lblSubtitle.text = [NSString stringWithFormat:@"To offset the damage of %@ lbs. of CO2, you’d have to plant %@ trees annually.", strCO2, strTree];
            break;
            
        case kEnvironmentTV:
            lblSubtitle.text = [NSString stringWithFormat:@"%@ lbs. of CO2 is like leaving a plasma TV on for %@ hours.", strCO2, strTV];
            break;
            
        case kEnvironmentWasher:
            lblSubtitle.text = [NSString stringWithFormat:@"%@ lbs. of CO2 is like running %@ loads of laundry.", strCO2, strWasher];
            break;
            
        case kEnvironmentGarbage:
            lblSubtitle.text = [NSString stringWithFormat:@"%@ lbs. of CO2 is the same as disposing %@ bags of garbage.", strCO2, strGarbage];
            break;
            
        default:
            break;
    }
}


- (void)sliderOpened
{
    hasSliderOpened = TRUE;
    
    [self updateEnvironmentLabel];
    
    lblSubtitle.hidden = YES;
    lblTitle.text = @"Think of your vehicle’s annual emissions this way:";
}


- (void)sliderClosed
{
    [self updateEnvironmentLabel];
    lblSubtitle.hidden = NO;
}


- (IBAction)showEVVideo:(id)sender
{
    NSString *movieName = @"Environment_SM";
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:movieName, @"movieName", @"True", @"hasControls", @"True", @"fadeIn", @"True", @"fadeOut", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayMovie" object:self userInfo:dict];
}


#pragma - scroll view methods

- (UIView *)loadViewForPage:(NSUInteger)pageIndex {
	UIImage *image = nil;
	switch(pageIndex % [self numberOfPages]) {
     case 0: image = [UIImage imageNamed:@"tree.png"]; break;
     case 1: image = [UIImage imageNamed:@"tv.png"]; break;
     case 2: image = [UIImage imageNamed:@"washer.png"]; break;
     case 3: image = [UIImage imageNamed:@"trashcan.png"]; break;
     }
    //image = [UIImage imageNamed:[arrImageNames objectAtIndex:(pageIndex % [self numberOfPages])]];
	UIImageView *pageView = [[[UIImageView alloc] initWithImage:image] autorelease];
	pageView.contentMode = UIViewContentModeScaleToFill;
	return pageView;
}

- (CGRect)alignView:(UIView *)view forPage:(NSUInteger)pageIndex inRect:(CGRect)rect {
	UIImageView *imageView = (UIImageView *)view;
	CGSize imageSize = imageView.image.size;
	CGFloat ratioX = rect.size.width / imageSize.width, ratioY = rect.size.height / imageSize.height;
	CGSize size = (ratioX < ratioY ?
				   CGSizeMake(rect.size.width, ratioX * imageSize.height) :
				   CGSizeMake(ratioY * imageSize.width, rect.size.height));
    
	return CGRectMake(rect.origin.x + (rect.size.width - size.width) / 2,
					  rect.origin.y + (rect.size.height - size.height) / 2,
					  size.width, size.height);
}

- (NSUInteger)numberOfPages {
	return 4;
}

- (UIView *)viewForPhysicalPage:(NSUInteger)pageIndex {
	NSParameterAssert(pageIndex >= 0);
	NSParameterAssert(pageIndex < [self.pageViews count]);
	
	UIView *pageView;
	if ([self.pageViews objectAtIndex:pageIndex] == [NSNull null]) {
		pageView = [self loadViewForPage:pageIndex];
		[self.pageViews replaceObjectAtIndex:pageIndex withObject:pageView];
		[dsScrollView addSubview:pageView];
	} else {
		pageView = [self.pageViews objectAtIndex:pageIndex];
	}
	return pageView;
}

- (CGSize)pageSize {
	return dsScrollView.frame.size;
}

- (BOOL)isPhysicalPageLoaded:(NSUInteger)pageIndex {
	return [self.pageViews objectAtIndex:pageIndex] != [NSNull null];
}

- (void)layoutPhysicalPage:(NSUInteger)pageIndex {
	UIView *pageView = [self viewForPhysicalPage:pageIndex];
	CGSize pageSize = [self pageSize];
	pageView.frame = [self alignView:pageView forPage:[self pageForPhysicalPage:pageIndex] inRect:CGRectMake(pageIndex * pageSize.width, 0, pageSize.width, pageSize.height)];
}


- (void)currentPageIndexDidChange {
	[self layoutPhysicalPage:_currentPhysicalPageIndex];
	if (_currentPhysicalPageIndex+1 < [self.pageViews count])
		[self layoutPhysicalPage:_currentPhysicalPageIndex+1];
	if (_currentPhysicalPageIndex > 0)
		[self layoutPhysicalPage:_currentPhysicalPageIndex-1];

    [self updateEnvironmentLabel];
}

- (void)layoutPages {
	CGSize pageSize = [self pageSize];
	dsScrollView.contentSize = CGSizeMake([self.pageViews count] * pageSize.width, pageSize.height);
	// move all visible pages to their places, because otherwise they may overlap
	for (NSUInteger pageIndex = 0; pageIndex < [self.pageViews count]; ++pageIndex)
		if ([self isPhysicalPageLoaded:pageIndex])
			[self layoutPhysicalPage:pageIndex];
}


- (NSUInteger)physicalPageIndex {
	CGSize pageSize = [self pageSize];
	return (dsScrollView.contentOffset.x + pageSize.width / 2) / pageSize.width;
}

- (void)setPhysicalPageIndex:(NSUInteger)newIndex {
	dsScrollView.contentOffset = CGPointMake(newIndex * [self pageSize].width, 0);
}

- (NSUInteger)physicalPageForPage:(NSUInteger)page {
	NSParameterAssert(page < [self numberOfPages]);
	return (_pageLoopEnabled ? page + [self numberOfPages] : page);
}

- (NSUInteger)pageForPhysicalPage:(NSUInteger)physicalPage {
	if (_pageLoopEnabled) {
		NSParameterAssert(physicalPage < 3 * [self numberOfPages]);
		return physicalPage % [self numberOfPages];
	} else {
		NSParameterAssert(physicalPage < [self numberOfPages]);
		return physicalPage;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    if (scrollView == dsScrollView)
    {
        if (_rotationInProgress)
            return; // UIScrollView layoutSubviews code adjusts contentOffset, breaking our logic
        
        NSUInteger newPageIndex = self.physicalPageIndex;
        if (newPageIndex == _currentPhysicalPageIndex ) return;
        
        //hasRotationHappened = TRUE;|| hasRotationHappened
        _currentPhysicalPageIndex = newPageIndex;
        _currentPageIndex = [self pageForPhysicalPage:_currentPhysicalPageIndex];
        
        [self currentPageIndexDidChange];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    if (scrollView == dsScrollView)
    {
        NSUInteger physicalPage = self.physicalPageIndex;
        NSUInteger properPage = [self physicalPageForPage:[self pageForPhysicalPage:physicalPage]];
        if (physicalPage != properPage)
            self.physicalPageIndex = properPage;
    } 
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
    
    UITouch *touch = [touches anyObject];
    startLocation = [touch locationInView:self.view];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    if (!hasRotationHappened) 
    {
        
        // move left
        if ((startLocation.x - location.x) > 50) 
        {
            hasRotationHappened = TRUE;
            CGRect frame = dsScrollView.frame;
            frame.origin.x = frame.size.width * (_currentPhysicalPageIndex + 1);
            frame.origin.y = 0;
            [dsScrollView scrollRectToVisible:frame animated:YES];
            [self scrollViewDidScroll:dsScrollView];
            [self scrollViewDidEndDecelerating:dsScrollView];
        }
        
        // move right
        if ((location.x - startLocation.x) > 50) 
        {        
            hasRotationHappened = TRUE;
            CGRect frame = dsScrollView.frame;
            frame.origin.x = frame.size.width * (_currentPhysicalPageIndex - 1);
            frame.origin.y = 0;
            [dsScrollView scrollRectToVisible:frame animated:YES];
            [self scrollViewDidScroll:dsScrollView];
            [self scrollViewDidEndDecelerating:dsScrollView];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    hasRotationHappened = FALSE;
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
}


@end
