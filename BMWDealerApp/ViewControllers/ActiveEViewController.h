//
//  ActiveEViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveEBMWViewController.h"
#import "ActiveEElectricViewController.h"

@interface ActiveEViewController : UIViewController {
    ActiveEBMWViewController *bmwViewController;
    ActiveEElectricViewController *electricViewController;
}

@end
