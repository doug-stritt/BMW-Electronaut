//
//  HelpViewController.h
//  BMWDealerApp
//
//  Created by Marc Brown on 10/10/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController {
    UIImageView *copyImageView;
}

- (void)displayHelpForSection:(NSString *)section;
- (IBAction)backButtonSelected:(id)sender;

@end
