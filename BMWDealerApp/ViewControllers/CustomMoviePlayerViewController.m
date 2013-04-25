//
//  CustomMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import "CustomMoviePlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation CustomMoviePlayerViewController

@synthesize movieURL;
@synthesize mp;
@synthesize fadeIn;
@synthesize fadeOut;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor blackColor]];
    self.view.hidden = YES;
}


- (void)playMovie:(NSURL *)moviePath withControls:(NSString *)hasControls fadeIn:(NSString *)doesFadeIn fadeOut:(NSString *)doesFadeOut
{
    if (mp != nil) {
        [mp.view removeFromSuperview];
        mp = nil;
    }
    
    movieURL = moviePath;
    fadeIn = doesFadeIn;
    fadeOut = doesFadeOut;
    
    mp = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    [mp.view setBackgroundColor:[UIColor blackColor]];
    
	[mp.view setFrame:CGRectMake(0, 0, 1024, 768)];
	[mp setFullscreen:YES];
	
    // Controls
    if ([hasControls isEqualToString:@"True"]) mp.controlStyle = MPMovieControlStyleFullscreen;
    else mp.controlStyle = MPMovieControlStyleNone;
    
	[self.view addSubview:mp.view];
	
    //[mp play];
    
	// May help to reduce latency
    [mp prepareToPlay];
    
    // Register that the load state changed (movie is ready)
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayerLoadStateChanged:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:nil];
	
    // Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
}


- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
    // Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        // Set frame of movieplayer
        [[mp view] setFrame:CGRectMake(0, 0, 1024, 768)];
        
        // Add movie player as subview
        [self.view addSubview:mp.view];
        //mp.initialPlaybackTime = -1.0;
        // Play the movie
        [mp play];
        
        // Fade in
        if ([fadeIn isEqualToString:@"True"]) {
            self.view.alpha = 0.0f;
            [UIView beginAnimations:@"anim" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5f];
            self.view.alpha = 1.0f;
            [UIView commitAnimations];
            
        }
        
        self.view.hidden = NO;
	}
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
	
 	// Remove observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    NSString *strCurrentPath = [movieURL absoluteString];
    NSString *strScanPath = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ATF_Intro_Scan" ofType:@"mp4"]] absoluteString];
    NSString *strElectronautPath = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1338_BMW_ActiveE_iPhone" ofType:@"mp4"]] absoluteString];
    NSString *strEVsPath = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"3carsMov1" ofType:@"mp4"]] absoluteString];
    NSString *strActiveEPath = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"3carsMov2" ofType:@"mp4"]] absoluteString];
    NSString *strReservePath = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"3carsMov3" ofType:@"mp4"]] absoluteString];
    // Scan video check
    if ([strCurrentPath isEqualToString:strScanPath]) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"1338_BMW_ActiveE_iPhone" ofType:@"mp4"];
        [self playMovie:[NSURL fileURLWithPath:moviePath] withControls:@"True" fadeIn:@"False" fadeOut:@"True"];
        
    // Electronaut video check
    } else if ([strCurrentPath isEqualToString:strElectronautPath]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"introViewControllerSetBackgroundImage" object:self];
        
        [UIView beginAnimations:@"anim" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5f];
        self.view.alpha = 0.0f;
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(remove) userInfo:nil repeats:NO];
        
    // Intro videos check
    } else if ([strCurrentPath isEqualToString:strEVsPath] || [strCurrentPath isEqualToString:strActiveEPath] || [strCurrentPath isEqualToString:strReservePath]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"introViewControllerSetBackgroundImage" object:self];
        [self remove];
        
    } else {
        
        // Fade out
        if ([fadeOut isEqualToString:@"True"]) {
            [UIView beginAnimations:@"anim" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5f];
            self.view.alpha = 0.0f;
            [UIView commitAnimations];
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(remove) userInfo:nil repeats:NO];
            
        // Everything else
        } else [self remove];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"videoComplete" object:self];
}


- (void)remove
{
    [self.view removeFromSuperview];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)dealloc 
{
	[mp release];
	[movieURL release];
    [fadeIn release];
    [fadeOut release];
	[super dealloc];
}

@end
