//
//  ActiveEViewController.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ActiveEViewController.h"


@implementation ActiveEViewController

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
    
    // 100% BMW
    bmwViewController = [[ActiveEBMWViewController alloc] initWithNibName:@"ActiveEBMWViewController" bundle:nil];
    [self.view addSubview:bmwViewController.view];
    
    // 100% Electric
    electricViewController = [[ActiveEElectricViewController alloc] initWithNibName:@"ActiveEElectricViewController" bundle:nil];
    electricViewController.view.hidden = YES;
    [self.view addSubview:electricViewController.view];
    
    // Set Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sectionToggle) name:@"sectionToggle" object:nil];
}


- (void)sectionToggle
{
    // Turn on both sections
    [bmwViewController on];
    [electricViewController on];
    
    // Toggle sections
    bmwViewController.view.hidden = !bmwViewController.view.hidden;
    electricViewController.view.hidden = !electricViewController.view.hidden;
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
