//
//  CustomMoviePlayerViewController.h
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CustomMoviePlayerViewController : UIViewController <MPMediaPlayback, MPMediaPickerControllerDelegate> 
{
	MPMoviePlayerController *mp;
    NSString *fadeIn;
    NSString *fadeOut;
}

@property (nonatomic, retain) NSURL *movieURL;
@property (nonatomic, retain) MPMoviePlayerController *mp;
@property (nonatomic, retain) NSString *fadeIn;
@property (nonatomic, retain) NSString *fadeOut;

- (void)playMovie:(NSURL *)moviePath withControls:(NSString *)hasControls fadeIn:(NSString *)doesFadeIn fadeOut:(NSString *)doesFadeOut;
- (void)remove;

@end
