//
//  CSImageAnnotationView.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSImageAnnotationView : MKPinAnnotationView
{
    UIImage *myImage;
}
@property(nonatomic,retain) UIImage *myImage;

@end