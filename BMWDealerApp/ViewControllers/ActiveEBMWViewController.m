//
//  ActiveEBMWViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ActiveEBMWViewController.h"
#import "AudioManager.h"

@implementation ActiveEBMWViewController

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self off];
    
    // Fade in
    self.view.alpha = 0.0f;
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    self.view.alpha = 1.0f;
    [UIView commitAnimations];
}


- (void)on
{
    bmwBtn.enabled = NO;
    performanceBtn.hidden = comfortBtn.hidden = designBtn.hidden = efficientBtn.hidden = titleImage.hidden = NO;
}


- (void)off
{
    bmwBtn.enabled = YES;
    performanceBtn.hidden = comfortBtn.hidden = designBtn.hidden = efficientBtn.hidden = titleImage.hidden = YES;
}


- (IBAction)bmwClick:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [self on];
}


- (IBAction)electricClick:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    // Remove current popup
    if (currentPopup != nil) [currentPopup.view removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionToggle" object:self];
}


- (IBAction)optionClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // Remove current popup
    if (currentPopup != nil) [currentPopup.view removeFromSuperview];
    
    // Determine which popup to open
    NSString *imageStr;
    int xPos, yPos;
    
    // Performance
    if (button.tag == 1) {
        imageStr = @"activee-100bmw-performance.png";
        xPos = 29;
        yPos = 124;
    
    // Comfort
    } else if (button.tag == 2) {
        imageStr = @"activee-100bmw-comfort-convenience.png";
        xPos = 174;
        yPos = 40;
        
    // Design
    } else if (button.tag == 3) {
        imageStr = @"activee-100bmw-design.png";
        xPos = 610;
        yPos = 125;
        
    // Efficient Dynamics
    } else if (button.tag == 4) {
        imageStr = @"activee-100bmw-efficient-dynamics.png";
        xPos = 560;
        yPos = 125;
    }
    
    // Open popup
    currentPopup = [[ActiveEPopupView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    CGRect pnt = currentPopup.view.frame;
    pnt.origin.x = xPos;
    pnt.origin.y = yPos;
    currentPopup.view.frame = pnt;
    currentPopup.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.view addSubview:currentPopup.view];
    
    // Scale up
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    currentPopup.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
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
