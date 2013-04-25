//
//  ReadyViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ReadyViewController.h"
#import "AudioManager.h"

@implementation ReadyViewController

@synthesize pageController;

const NSString * BUTTON_KEY = @"button";
const NSString * CONTENT_KEY = @"content";

bool webViewContainerAdded;
bool webViewContainerActive;
CGRect webViewContainerFrame;


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
	[tabs release];
	[pageController release];
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
	
	tabs = [[NSArray arrayWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:contentViewReservation, CONTENT_KEY, buttonReservation, BUTTON_KEY, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:contentViewConsultation, CONTENT_KEY, buttonConsultation, BUTTON_KEY, nil],
			[NSDictionary dictionaryWithObjectsAndKeys:contentViewLease, CONTENT_KEY, buttonLease, BUTTON_KEY, nil],
			nil] retain];
	
	currentButton = buttonReservation;
	currentContentView = contentViewReservation;
	
	currentButton.selected = TRUE;
	[tabView addSubview:currentContentView];
	
	webViewContainerAdded = FALSE;
	webViewContainerActive = FALSE;
	
	UISwipeGestureRecognizer * swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeContentView:)];
	swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[tabView addGestureRecognizer:swipeGestureRecognizer];
	[swipeGestureRecognizer release];
	
	swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeContentView:)];
	swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[tabView addGestureRecognizer:swipeGestureRecognizer];
	[swipeGestureRecognizer release];
    
    // Page Control user
    pageController = [[PageControl alloc] initWithFrame:CGRectMake(462, 670, 100, 20)];
    pageController.currentPage = 0;
    pageController.numberOfPages = 3;
    pageController.delegate = self;
    [self.view addSubview:pageController];
    
    // update copy
    NSDate *dateToday = [NSDate date];
    
    NSString *strDate  = @"12-01-2011";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *datePass = [[[NSDate alloc] init] autorelease];
    datePass = [dateFormatter dateFromString:strDate];
    [dateFormatter release];
    
    if ([dateToday compare:datePass] == NSOrderedAscending) 
    {
        btnStayInformed.hidden = NO;
        btnReserveNow.hidden = YES;
        //lblResereLeft.hidden = YES;
        lblResereCenterTop.text = @"That experience will begin in December 2011, when the BMW Electronaut recruitment period will launch, and the reservation form will be available.";
        lblResereCenterMiddle.text = @"Each BMW ActiveE will be available on a first-come, first-served basis. Please choose to stay informed so we can notify you as soon as the reservation process opens.";
    } else 
    {
        btnStayInformed.hidden = YES;
        btnReserveNow.hidden = NO;
        lblResereLeft.hidden = NO;
        lblResereCenterTop.text = @"Fill out our iPad reservation form for an opportunity to become one of the first BMW Electronauts—an owner of the only vehicle that's an all-electric Ultimate Driving Machine®.";
        lblResereCenterMiddle.text = @"Each BMW ActiveE will be available on a first-come, first-served basis. So please submit your reservation as soon as possible.";
    }
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


- (IBAction)tabButtonPressed:(id)sender
{
    [[AudioManager sharedAudioManager] playClick1];
	if ((UIButton *)sender == currentButton)
	{
		return;
	}
	
	[self changeToTabViewContent:((UIButton *)sender).tag - 1];
}

- (IBAction)reserveNowButtonPressed:(id)sender
{
    [[AudioManager sharedAudioManager] playClick1];
    NSDate *dateToday = [NSDate date];
    
    NSString *strDate  = @"12-01-2011";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *datePass = [[[NSDate alloc] init] autorelease];
    datePass = [dateFormatter dateFromString:strDate];
    [dateFormatter release];
    
    if ([dateToday compare:datePass] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"Can't fill out a reservation form without a password."
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [self toggleWebView:[NSURL URLWithString:RESERVATION_URL]];
    }	
}


- (IBAction)stayInformedButtonPressed:(id)sender
{
    [[AudioManager sharedAudioManager] playClick1];
	[self toggleWebView:[NSURL URLWithString:STAY_INFORMED_URL]];
}


- (IBAction)leaseTermsButtonPressed:(id)sender
{
    [[AudioManager sharedAudioManager] playClick1];
	NSDictionary *dict = [[[NSDictionary alloc] initWithObjectsAndKeys:@"lease", @"section", nil] autorelease];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showHelp" object:self userInfo:dict];
}


- (IBAction)legalButtonPressed:(id)sender
{
    [[AudioManager sharedAudioManager] playClick1];
	[self toggleWebView:[NSURL URLWithString:LEGAL_URL]];
}


- (IBAction)webViewContainerBackButtonPressed:(id)sender
{
	[self toggleWebView:nil];
}


- (void)toggleWebView:(NSURL *)url
{
	CGRect webViewContainerFrame;
    
	if (webViewContainerActive)
	{
		webViewContainerFrame = webViewContainer.frame;
		webViewContainerFrame.origin.y = 700;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showLogo" object:self];
	}
	else
	{
		if (webViewContainerAdded)
		{
			webViewContainerFrame = webViewContainer.frame;
		}
		else
		{
			webViewContainerFrame = CGRectMake(0, 700, 1024, 768);
			[webViewContainer setFrame:webViewContainerFrame];
			[self.view addSubview:webViewContainer];
			webViewContainerAdded = TRUE;
		}
		webViewContainerFrame.origin.y = 0;
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"hideLogo" object:self];
	}
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
	{
		[UIView transitionWithView:self.view
						duration:0.5
		 				options:UIViewAnimationOptionCurveEaseInOut
						animations:^{ [webViewContainer setFrame:webViewContainerFrame]; }
						completion:NULL];
	}
	else
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[webViewContainer setFrame:webViewContainerFrame];
		//[self setView:webViewContainer];
		
		[UIView commitAnimations];
	}
	
	webViewContainerActive = !webViewContainerActive;
}

- (void)changeToTabViewContent:(NSInteger)tabId
{
    pageController.currentPage = (int)tabId;
	NSDictionary * tabData = [tabs objectAtIndex:tabId];
	
	UIButton * newButton = [tabData objectForKey:BUTTON_KEY];
	UIView * newContentView = [tabData objectForKey:CONTENT_KEY];
	
	currentButton.selected = FALSE;
	newButton.selected = TRUE;
	
	CGRect startFrame;
	if (newButton.tag > currentButton.tag)
	{
		startFrame = CGRectMake(tabView.frame.size.width, 0, tabView.frame.size.width, tabView.frame.size.height);
	}
	else
	{
		startFrame = CGRectMake(-tabView.frame.size.width, 0, tabView.frame.size.width, tabView.frame.size.height);
	}
	CGRect endFrame = CGRectMake(-startFrame.origin.x, 0, tabView.frame.size.width, tabView.frame.size.height);
	
	[newContentView setFrame:startFrame];
	[tabView addSubview:newContentView];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
	{
		[UIView transitionWithView:tabView
						  duration:0.5
						   options:UIViewAnimationOptionCurveEaseInOut
						animations:^{
							[newContentView setFrame:currentContentView.frame];
							[currentContentView setFrame:endFrame];
						}
						completion:^(BOOL finished){
							[currentContentView removeFromSuperview];
							currentContentView = newContentView;
						}
		 ];
		
		currentButton = newButton;
	}
	else
	{
		[self.view setUserInteractionEnabled:FALSE];
		
		[UIView beginAnimations:@"ChangeTabContentView" context:newContentView];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		
		[newContentView setFrame:currentContentView.frame];
		[currentContentView setFrame:endFrame];
		
		[UIView commitAnimations];
		
		currentButton = newButton;
	}
}


- (void)swipeContentView:(UISwipeGestureRecognizer *)recognizer
{
	NSInteger currentTabId = currentButton.tag - 1;
	
	switch (recognizer.direction)
	{
		case UISwipeGestureRecognizerDirectionLeft:
		{
			if (currentTabId < 2)
			{
				[self changeToTabViewContent:currentTabId + 1];
			}
			else
			{
				[self bounceTabViewContent:TRUE];
			}
			
			break;
		}
		case UISwipeGestureRecognizerDirectionRight:
		{
			if (currentTabId > 0)
			{
				[self changeToTabViewContent:currentTabId - 1];
			}
			else
			{
				[self bounceTabViewContent:FALSE];
			}
			
			break;
		}
		default:
		{
			NSLog(@"Unsupported swipe gesture");
			break;
		}
	}
}

- (void)bounceTabViewContent:(BOOL)directionLeft
{
	[self.view setUserInteractionEnabled:FALSE];
	
	[UIView beginAnimations:@"BounceTabContentView" context:nil];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	[currentContentView setFrame:CGRectMake((directionLeft ? -tabView.frame.size.width : tabView.frame.size.width) / 8, 0, tabView.frame.size.width, tabView.frame.size.height)];
	
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"ChangeTabContentView"])
	{
		[currentContentView removeFromSuperview];
		currentContentView = (UIView *)context;
		
		[self.view setUserInteractionEnabled:TRUE];
	}
	else if ([animationID isEqualToString:@"BounceTabContentView"])
	{
		[UIView beginAnimations:@"Bounce2TabContentView" context:nil];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		
		[currentContentView setFrame:CGRectMake(0, 0, tabView.frame.size.width, tabView.frame.size.height)];
		
		[UIView commitAnimations];
	}
	else if ([animationID isEqualToString:@"Bounce2TabContentView"])
	{
		[self.view setUserInteractionEnabled:TRUE];
	}
}


#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IdleTimerReset" object:self];
}


#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	[self toggleWebView:[NSURL URLWithString:RESERVATION_URL]];
}


@end
