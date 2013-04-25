//
//  CSImageAnnotation.m
//  gimme
//
//  Created by vtoms on 9/23/11.
//  Copyright (c) 2011 gimme labs. All rights reserved.
//
//
//  CSImageAnnotationView.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//
#import "CSImageAnnotationView.h"

#define kHeight 39
#define kWidth  50
#define kBorder 0

@implementation CSImageAnnotationView
@synthesize myImage;


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	if( (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) )
	{
		self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	}
    
	return self;
}

- (void)layoutSubviews;
{
    /*	if ( [loc.smallimage rangeOfString:@"_PO"].length == 0 )
     {
     self.image = [UIImage imageNamed:loc.FilterForLocation.map_pin_icon];
     }
     else
     {
     self.image = [UIImage imageNamed:loc.smallimage];
     } */
    // FIX
    self.image = myImage;
}

-(void) dealloc
{
	[super dealloc];
}


@end