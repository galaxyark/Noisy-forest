//
//  CCLayerControlPanel.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayerControlPanel.h"
#import "MicrophoneController.h"

static CCLayerControlPanel *controller = nil;

@interface CCLayerControlPanel ()

@end

@implementation CCLayerControlPanel
@synthesize joystick, micVolume, fmodFreq;

+(CCScene *) scene {
    
    CCScene *scene = [CCScene node];
    
    CCLayerControlPanel *layer = [CCLayerControlPanel sharedController];
    
    [scene addChild:layer];
    
    return scene;
}

+(CCLayerControlPanel *) sharedController {
    
    if (!controller) {
        
        controller = [[CCLayerControlPanel alloc] init];
    }
    
    return controller;
}

-(id) init {
    
    if (self = [super init]) {
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        beReady = false;
        
        [self initJoystick];
        [self initSkillPanel];
        
        self.micVolume = [CCLabelTTF labelWithString:@"Volume" fontName:@"Marker Felt" fontSize:28];
        [self.micVolume setPosition:ccp(s.width*0.9f, s.height*0.9f)];
        [self.micVolume setColor:ccBLACK];
        [self addChild:micVolume];
        
        self.fmodFreq = [CCLabelTTF labelWithString:@"Frequency" fontName:@"Marker Felt" fontSize:28];
        [self.fmodFreq setPosition:ccp(s.width*0.9, s.height*0.85)];
        [self.fmodFreq setColor:ccBLACK];
        [self addChild:fmodFreq];
        
        [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(updateLabel:) forTarget:self interval:0.1f paused:NO];
         beReady = true;
        
    }
    
    return self;
}

-(void) initJoystick {
    
    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpad.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystick.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    [joystickBase setPosition:ccp(124, 80)];
    [self addChild:joystickBase];
    joystick = [joystickBase.joystick retain];
}

-(void) initSkillPanel {
    
    skillpanel = [[[SkillPanelBase alloc] init] autorelease];
    [skillpanel setPosition:skillpanel->oriPos];
    [self addChild:skillpanel];
}

-(void) updateLabel:(ccTime)dt {
    
    if ([MicrophoneController sharedInstance]->isListening) {
        
        [self.micVolume setString:[NSString stringWithFormat:@"Volume: %.1f", [MicrophoneController sharedInstance].lowPassResults]];
    }
    else {
        
        [self.micVolume setString:@"Volume: Off"];
    }
    
    if ([MicrophoneController sharedInstance]->isFmodEnable) {
        [self.fmodFreq setString:[NSString stringWithFormat:@"Frequency: %7.2f", [MicrophoneController sharedInstance].frequency]];
    }
    else {
        
        [self.fmodFreq setString:@"Frequency: Off"];
    }
    
}

-(void) refresh {
    
    controller = nil;
}

-(void) dealloc {
    
    [joystick release];
    [super dealloc];
}

@end
