//
//  AudioManager.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 10/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

/*
 Class Name: AudioManager
 Features  : This class is responsible for playing the audio
 */

@interface AudioManager : NSObject <AVAudioPlayerDelegate> {
    
    NSURL *soundFileURL;
}

+(AudioManager*)sharedAudioManager;

- (void)playClick1;
- (void)playClick2;
- (void)playClick3;
- (void)playClick4;
- (void)playScanFinger;
- (void)playTick;
- (void)playWindowOpen;

@end
