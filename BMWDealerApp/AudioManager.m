//
//  AudioManager.m
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 10/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import "AudioManager.h"

static AudioManager *sharedInstance=nil;

@implementation AudioManager

+ (AudioManager*)sharedAudioManager
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedAudioManager];
}

-(id)copyWithZone:(NSZone*)zone
{
	return self;
}

-(id)retain
{
	return self;
}

-(unsigned)retainCount
{
	return UINT_MAX;
}

-(void)release
{
	
}

-(id)autorelease
{
	return self;
}

//*****************************************************************

-(void)configurePlayerForSounds:(NSURL*)soundFilePath 
{	
	[[AVAudioSession sharedInstance] setActive:YES error:nil];	
	
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFilePath  error: nil];		
	[newPlayer prepareToPlay];
	[newPlayer setDelegate: self];	
	
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
	[newPlayer play];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player stop];
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}


- (void)playClick1
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click1" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


- (void)playClick2
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click2" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


- (void)playClick3
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click3" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath]; 
}


- (void)playClick4
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"click4" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


- (void)playScanFinger
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"scanFinger" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


- (void)playTick
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ticker" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


- (void)playWindowOpen
{
    NSURL *sndpath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"windowOpen" ofType:@"aif"]];
	[self configurePlayerForSounds:sndpath];
}


-(void)dealloc
{
	[super dealloc];
}

@end
