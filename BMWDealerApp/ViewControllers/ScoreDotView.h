//
//  ScoreDotView.h
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreDotView : UIView {
    UIImageView *onView;
    UIImageView *offView;
}

@property (nonatomic, retain) UIImageView *onView;
@property (nonatomic, retain) UIImageView *offView;

- (void)setState:(NSString *)state;

@end
