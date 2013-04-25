//
//  ScoreboardViewController.m
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ScoreboardViewController.h"
#import "ScoreDigitView.h"


@implementation ScoreboardViewController

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    digitViewsArr = [[NSMutableArray alloc] init];
    savingsIndex = 0;
    
    // Holder
    UIView *scoreboardHolder = [[[UIView alloc] initWithFrame:CGRectMake(83, 27, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    [self.view addSubview:scoreboardHolder];
    
    // Digits (right to left)
    ScoreDigitView *digit7View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(497, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit7View setType:@"digit"];
    [digit7View setValue:@"0" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit7View];
    [digitViewsArr addObject:digit7View];
    
    ScoreDigitView *digit6View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(434, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit6View setType:@"digit"];
    [digit6View setValue:@"0" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit6View];
    [digitViewsArr addObject:digit6View];
    
    // Period
    ScoreDigitView *periodView = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(402, 50, DOT_WIDTH * 2, DOT_HEIGHT * 2) withNumColumns:2 andNumRows:2] autorelease];
    [periodView setType:@"period"];
    [periodView setValue:@"." withAnimationDelay:0.0];
    [scoreboardHolder addSubview:periodView];
    [digitViewsArr addObject:periodView];
    
    ScoreDigitView *digit5View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(343, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit5View setType:@"digit"];
    [digit5View setValue:@"0" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit5View];
    [digitViewsArr addObject:digit5View];
    
    ScoreDigitView *digit4View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(280, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit4View setType:@"digit"];
    [digit4View setValue:@"-" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit4View];
    [digitViewsArr addObject:digit4View];
    
    ScoreDigitView *digit3View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(217, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit3View setType:@"digit"];
    [digit3View setValue:@"-" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit3View];
    [digitViewsArr addObject:digit3View];
    
    // Comma
    ScoreDigitView *commaView = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(185, 50, DOT_WIDTH * 2, DOT_HEIGHT * 2) withNumColumns:2 andNumRows:2] autorelease];
    [commaView setType:@"comma"];
    [commaView setValue:@"-" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:commaView];
    [digitViewsArr addObject:commaView];
    
    ScoreDigitView *digit2View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(126, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit2View setType:@"digit"];
    [digit2View setValue:@"-" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit2View];
    [digitViewsArr addObject:digit2View];
    
    ScoreDigitView *digit1View = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(63, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [digit1View setType:@"digit"];
    [digit1View setValue:@"-" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:digit1View];
    [digitViewsArr addObject:digit1View];
    
    ScoreDigitView *dollarView = [[[ScoreDigitView alloc] initWithFrame:CGRectMake(0, 0, DOT_WIDTH * 5, DOT_HEIGHT * 7) withNumColumns:5 andNumRows:7] autorelease];
    [dollarView setType:@"digit"];
    [dollarView setValue:@"$" withAnimationDelay:0.0];
    [scoreboardHolder addSubview:dollarView];
    
    // Test Numbers
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
}


- (void)updateScoreboard:(float)savings
{
    // Set min/max threshholds
    if (savings < 0.00) savings = 0.00;
    else if (savings > 99999.99) savings = 99999.99;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *savingsStr = [formatter stringFromNumber:[NSNumber numberWithFloat:savings]];
    [formatter release];
    
    ScoreDigitView *digitView;
    NSString *digitStr;
    NSDictionary *dict;
    int digitIndex = [savingsStr length] - 1;
    for (int i = 0; i < [digitViewsArr count]; i++) {
        digitView = [digitViewsArr objectAtIndex:i];
        if (digitIndex < 0) digitStr = @"-";
        else digitStr = [NSString stringWithFormat:@"%c", [savingsStr characterAtIndex:digitIndex]];
        if ([digitStr isEqualToString:@"$"]) digitStr = @"-";
        dict = [NSDictionary dictionaryWithObjectsAndKeys:digitView, @"view", digitStr, @"value", [NSNumber numberWithFloat:0.0], @"delay", nil];
        [NSTimer scheduledTimerWithTimeInterval:i * 0.075 target:self selector:@selector(updateDigit:) userInfo:dict repeats:NO];
        digitIndex--;
    }

}


- (void)updateDigit:(NSNotification *)notification
{
    ScoreDigitView *digitView = [[notification userInfo] objectForKey:@"view"];
    NSString *digitStr = [[notification userInfo] objectForKey:@"value"];
    float delay = [[[notification userInfo] objectForKey:@"delay"] floatValue];
    [digitView setValue:digitStr withAnimationDelay:delay];
}


- (void)test
{
    float savings;
    switch (savingsIndex) {
        case 0 :
            savings = 0.01;
            break;
            
        case 1 :
            savings = 0.12;
            break;
            
        case 2 :
            savings = 1.23;
            break;
            
        case 3 :
            savings = 12.34;
            break;
            
        case 4 :
            savings = 123.45;
            break;
            
        case 5 :
            savings = 1234.56;
            break;
            
        case 6:
            savings = 12345.67;
            break;
            
        default:
            break;
    }
    
    [self updateScoreboard:savings];
    
    if (savingsIndex == 6) savingsIndex = 0;
    else savingsIndex++;
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
