//
//  ActiveEBMWViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ActiveEElectricViewController.h"
#import "AudioManager.h"

@implementation ActiveEElectricViewController

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
    
    [self on];
    
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
    electricBtn.enabled = NO;
    chargingBtn.hidden = batteriesBtn.hidden = rangeBtn.hidden = titleImage.hidden = NO;
}


- (void)off
{
    electricBtn.enabled = YES;
    chargingBtn.hidden = batteriesBtn.hidden = rangeBtn.hidden = titleImage.hidden = NO;
}


- (IBAction)bmwClick:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    // Remove current popup
    if (currentPopup != nil) [currentPopup.view removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionToggle" object:self];
}


- (IBAction)electricClick:(id)sender
{
    [[AudioManager sharedAudioManager] playClick4];
    [self on];
}


- (IBAction)optionClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    // Remove current popup
    if (currentPopup != nil) [currentPopup.view removeFromSuperview];
    
    // Determine which popup to open
    NSString *imageStr;
    int xPos, yPos;
    
    // Charging
    if (button.tag == 1) {
        imageStr = @"activee-100electric-charging.png";
        xPos = 167;
        yPos = 27;
    
    // Batteries
    } else if (button.tag == 2) {
        imageStr = @"activee-100electric-batteries.png";
        xPos = 611;
        yPos = 132;
        
    // Range
    } else if (button.tag == 3) {
        imageStr = @"activee-100electric-range.png";
        xPos = 561;
        yPos = 137;
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
