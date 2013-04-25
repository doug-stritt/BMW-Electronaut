//
//  ScoreDigitView.h
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScoreDigitView : UIView {
    NSMutableArray *dotArr;
}

- (id)initWithFrame:(CGRect)frame withNumColumns:(int)colNum andNumRows:(int)rowNum;
- (void)setType:(NSString *)typeStr;
- (void)setValue:(NSString *)valueStr withAnimationDelay:(float)delay;

@end
