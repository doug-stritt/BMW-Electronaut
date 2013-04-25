//
//  ScoreboardViewController.h
//  BMWDealerApp
//
//  Created by Marc Brown on 9/20/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DOT_WIDTH 10
#define DOT_HEIGHT 10


@interface ScoreboardViewController : UIViewController {
    NSMutableArray *digitViewsArr;
    int savingsIndex;
}

- (void)updateScoreboard:(float)savings;

@end
