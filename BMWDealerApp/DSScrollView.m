//
//  DSScrollView.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/13/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "DSScrollView.h"


@implementation DSScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
    // If not dragging, send event to next responder
    if (!self.dragging) 
        [self.nextResponder touchesEnded: touches withEvent:event]; 
    else
        [super touchesEnded: touches withEvent: event];
}


- (void)dealloc
{
    [super dealloc];
}


@end
