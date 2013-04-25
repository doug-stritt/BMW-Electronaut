//
//  ScoreDigitView.m
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "ScoreDigitView.h"
#import "ScoreDotView.h"
#import "ScoreboardViewController.h"


@implementation ScoreDigitView

- (id)initWithFrame:(CGRect)frame withNumColumns:(int)colNum andNumRows:(int)rowNum
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Init
        dotArr = [[NSMutableArray alloc] init];
        
        ScoreDotView *dotView;
        int xPos = 0;
        int yPos = 0;
        // Rows
        for (int i = 0; i < rowNum; i++) {
            
            // Columns
            for (int j = 0; j < colNum; j++) {
                
                dotView = [[ScoreDotView alloc] initWithFrame:CGRectMake(xPos, yPos, DOT_WIDTH, DOT_HEIGHT)];
                [self addSubview:dotView];
                [dotArr addObject:dotView];
                xPos += DOT_WIDTH;
            }
            
            xPos = 0;
            yPos += DOT_HEIGHT;
        }
    }
    return self;
}


- (void)setType:(NSString *)typeStr
{
    // Digit
    if ([typeStr isEqualToString:@"digit"]) {
        
    // Comma
    } else if ([typeStr isEqualToString:@"comma"]) {
        // Hide bottom left dot
        ScoreDotView *dot = [dotArr objectAtIndex:2];
        dot.offView.hidden = YES;
        
    // Period
    } else if ([typeStr isEqualToString:@"period"]) {
        
    }
}


- (void)setValue:(NSString *)valueStr withAnimationDelay:(float)delay
{
    NSArray *valuesArr;
    ScoreDotView *dot;
    // 0
    if ([valueStr isEqualToString:@"0"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 1
    } else if ([valueStr isEqualToString:@"1"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     nil] autorelease];
    // 2
    } else if ([valueStr isEqualToString:@"2"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     nil] autorelease];
    // 3
    } else if ([valueStr isEqualToString:@"3"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 4
    } else if ([valueStr isEqualToString:@"4"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 5
    } else if ([valueStr isEqualToString:@"5"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 6
    } else if ([valueStr isEqualToString:@"6"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 7
    } else if ([valueStr isEqualToString:@"7"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 8
    } else if ([valueStr isEqualToString:@"8"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // 9
    } else if ([valueStr isEqualToString:@"9"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // $
    } else if ([valueStr isEqualToString:@"$"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
        // - (Clear all values)
    } else if ([valueStr isEqualToString:@"-"]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:NO], 
                     nil] autorelease];
    // ,
    } else if ([valueStr isEqualToString:@","]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:NO], 
                     [NSNumber numberWithBool:YES], 
                     nil] autorelease];
    
    // .
    } else if ([valueStr isEqualToString:@"."]) {
        valuesArr = [[[NSArray alloc] initWithObjects:
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     [NSNumber numberWithBool:YES], 
                     nil] autorelease];
    }
    
    // Animate value
    /*CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anim.duration = delay;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    float startAlpha;
    float endAlpha;*/
    for (int i = 0; i < [dotArr count]; i++) {
        dot = [dotArr objectAtIndex:i];
        BOOL value;
        if (dot.offView.hidden == YES) value = YES;
        else value = ![[valuesArr objectAtIndex:i] boolValue];
        dot.onView.hidden = value;
        /*startAlpha = dot.onView.hidden;
        
        // Ignore for hidden off dots
        if (dot.offView.hidden == YES) endAlpha = 0.0;
        else endAlpha = [[valuesArr objectAtIndex:i] floatValue];
        
        anim.fromValue = [NSNumber numberWithFloat:startAlpha];
        anim.toValue = [NSNumber numberWithFloat:endAlpha];
        [dot.onView.layer addAnimation:anim forKey:@"animateOpacity"];*/
    }
}


- (void)dealloc
{
    [dotArr release];
    [super dealloc];
}

@end
