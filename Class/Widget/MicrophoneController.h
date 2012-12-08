//
//  MicrophoneController.h
//  MC
//
//  Created by Shengzhe Chen on 10/22/12.
//  Copyright (c) 2012 Shengzhe Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "fmod.hpp"
#import "fmod_errors.h"

@interface MicrophoneController : NSObject
{
    @protected
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    NSTimer *timer;
    FMOD::System *system;
    FMOD::Sound *sound;
    FMOD::Channel *channel;
    
    @public
    BOOL isListening;
    BOOL isFmodEnable;
    
    
}
+(MicrophoneController *)sharedInstance;
-(void) initMic;
-(void) startDetecting;
-(void) stopDetecting;
-(void) levelTimerCallback:(NSTimer *)timer;
-(void) startFrenquency;
-(void) stopFrequency;
-(void) timerUpdate:(NSTimer *)timer;

@property (atomic, assign)double lowPassResults;
@property (atomic, assign)double frequency;

@end
