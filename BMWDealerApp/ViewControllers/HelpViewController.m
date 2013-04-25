//
//  HelpViewController.m
//  BMWDealerApp
//
//  Created by Marc Brown on 10/10/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "HelpViewController.h"
#import "AudioManager.h"

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)displayHelpForSection:(NSString *)section
{
    if (copyImageView != nil) {
        [copyImageView removeFromSuperview];
        copyImageView = nil;
    }
    
    UIImage *copyImage = [UIImage imageNamed:[NSString stringWithFormat:@"help-copy-%@.png", section]];
    copyImageView = [[UIImageView alloc] initWithImage:copyImage];
    copyImageView.frame = CGRectMake((self.view.frame.size.width * 0.5) - (copyImage.size.width * 0.5), (self.view.frame.size.height * 0.5) - (copyImage.size.height * 0.5) + 35, copyImage.size.width, copyImage.size.height);
    [self.view addSubview:copyImageView];
}


- (IBAction)backButtonSelected:(id)sender
{
    [[AudioManager sharedAudioManager] playClick2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideHelp" object:self];
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
