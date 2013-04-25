//
//  ActiveEPopupView.m
//  BMWDealerApp
//
//  Created by Marc Brown on 9/12/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "ActiveEPopupView.h"
#import "AudioManager.h"

@implementation ActiveEPopupView

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        [[AudioManager sharedAudioManager] playWindowOpen];
        
        // BG
        self.view.backgroundColor = [UIColor clearColor];
        
        // Image
        UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self.view addSubview:imageView];
        
        // Close btn
        UIImage *closeImage = [UIImage imageNamed:@"activee-close-btn.png"];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.frame = CGRectMake(imageView.frame.size.width - (closeImage.size.width * 0.7),
                                    -(closeImage.size.height * 0.4),
                                    closeImage.size.width,
                                    closeImage.size.height);
        [closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        
        self.view.bounds = CGRectMake(0, -closeImage.size.height, image.size.width + closeImage.size.width, image.size.height + (closeImage.size.height * 2));
    }
    
    return self;
}


- (void)closeView
{
    [[AudioManager sharedAudioManager] playWindowOpen];
    // Scale down
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideView) userInfo:nil repeats:NO];
}


- (void)hideView
{
    self.view.hidden = YES;
}



- (void)dealloc
{
    [super dealloc];
}

@end
