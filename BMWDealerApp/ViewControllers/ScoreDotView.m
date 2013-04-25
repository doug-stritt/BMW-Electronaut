//
//  ScoreDotView.m
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ScoreDotView.h"


@implementation ScoreDotView

@synthesize onView;
@synthesize offView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Off
        UIImage *dotOff = [UIImage imageNamed:@"scoreboard-dot-off.png"];
        offView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dotOff.size.width, dotOff.size.height)];
        offView.image = dotOff;
        [self addSubview:offView];
        
        // On
        UIImage *dotOn = [UIImage imageNamed:@"scoreboard-dot-on.png"];
        onView = [[UIImageView alloc] initWithFrame:CGRectMake((dotOff.size.width * 0.5) - (dotOn.size.width * 0.5), (dotOff.size.height * 0.5) - (dotOn.size.height * 0.5), dotOn.size.width, dotOn.size.height)];
        onView.image = dotOn;
        //onView.hidden = YES;
        [self addSubview:onView];
    }
    return self;
}


- (void)setState:(NSString *)state
{
    // Off
    if ([state isEqualToString:@"off"]) {
        offView.hidden = NO;
        onView.hidden = YES;
        
    // On
    } else if ([state isEqualToString:@"on"]) {
        offView.hidden = YES;
        onView.hidden = NO;
        
    // Hidden
    } else if ([state isEqualToString:@"hidden"]) {
        offView.hidden = YES;
        onView.hidden = YES;
    }
}


- (void)dealloc
{
    [onView release];
    [offView release];
    [super dealloc];
}

@end
