//
//  MapAnnotation.h
//  MapPOI
//
//  Created by Marc Brown on 8/3/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString *title;
    NSString *subtitle;
    NSString *type;
    UIImage *myImage;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) UIImage *myImage;

- (id) initWithCoordinate: (CLLocationCoordinate2D) aCoordinate;

@end