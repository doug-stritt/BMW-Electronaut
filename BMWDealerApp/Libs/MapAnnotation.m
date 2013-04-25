//
//  MapAnnotation.m
//  MapPOI
//
//  Created by Marc Brown on 8/3/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize type;
@synthesize myImage;

- (id) initWithCoordinate: (CLLocationCoordinate2D) aCoordinate {
	if ((self = [super init])) coordinate = aCoordinate;
	return self;
}


- (void)dealloc {
    [super dealloc];
    [title release];
    [subtitle release];
    [type release];
}

@end
