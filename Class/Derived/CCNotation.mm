//
//  CCNotation.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCNotation.h"
#import "CCSharedData.h"
#import "CCLayerGame.h"
#import "MicrophoneController.h"


const float toneNode[5] = {20.0f, 40.0f, 50.0f, 70.0f, 90.0f};

@implementation CCNotation

+(CCNotation *) spriteWithFileName:(NSString *)filename {
    
    CCNotation *obj = [[[CCNotation alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    return obj;
}

-(id) init {
    
    if (self = [super init]) {
    
    }
    
    return self;
}

-(void) setupToneBar {
 
    toneBar = [PowerBar spriteWithFileName:@"vg_512_48_Time_Bar_Shell.png" barFile:@"vg_512_48_Time_Bar.png"];
    
    CCSprite *toneNote1 = [CCSprite spriteWithFile:@"vg_48_64_Time_Bar_Note.png"];
    CCSprite *toneNote2 = [CCSprite spriteWithFile:@"vg_48_64_Time_Bar_Note.png"];
    CCSprite *toneNote3 = [CCSprite spriteWithFile:@"vg_48_64_Time_Bar_Note.png"];
    CCSprite *toneNote4 = [CCSprite spriteWithFile:@"vg_48_64_Time_Bar_Note.png"];
    CCSprite *toneNote5 = [CCSprite spriteWithFile:@"vg_48_64_Time_Bar_Note.png"];
    
    CGSize contentSize = toneBar.base.contentSize;
    
    [toneNote1 setPosition:ccp(contentSize.width*0.225f, contentSize.height*0.5f)];
    [toneNote2 setPosition:ccp(contentSize.width*0.425f, contentSize.height*0.5f)];
    [toneNote3 setPosition:ccp(contentSize.width*0.525f, contentSize.height*0.5f)];
    [toneNote4 setPosition:ccp(contentSize.width*0.725f, contentSize.height*0.5f)];
    [toneNote5 setPosition:ccp(contentSize.width*0.925f, contentSize.height*0.5f)];
    
    [toneBar.base addChild:toneNote1];
    [toneBar.base addChild:toneNote2];
    [toneBar.base addChild:toneNote3];
    [toneBar.base addChild:toneNote4];
    [toneBar.base addChild:toneNote5];
    
    [toneBar setVisible:NO];
    toneBar.bar.percentage = 0.0f;

}

-(void) update:(ccTime)dt {
    
    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    
    if ([rio isVisualCollideWith:self radius:self.sprite.contentSize.width*0.5f]) {
        
        if (!isPlaying) {
            [self setupToneBar];
            [toneBar setPosition:ccp(rio.sprite.contentSize.width*0.5f, rio.sprite.contentSize.height+64.0f)];
            [rio.sprite addChild:toneBar];
            [toneBar setVisible:YES];
            isPlaying = YES;
            [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(updateTone:) forTarget:self interval:0.05 paused:NO];
            
            [[MicrophoneController sharedInstance] startDetecting];
            [[MicrophoneController sharedInstance] stopFrequency];
            
        }
    }
}

-(void) updateTone:(ccTime)dt {

    static float time = 0.0f;

    float volumn = [MicrophoneController sharedInstance].lowPassResults;
    
    float perf = toneBar.bar.percentage;
    
    perf += dt*10;
    
    if (perf >= 100.0f) {
        
        perf = 100.0f;
        time += dt;
        
        if (time > 2.0f) {
            
            [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(updateTone:) forTarget:self];
            isPlaying = NO;
            time = 0.0f;
            [toneBar removeFromParentAndCleanup:YES];
            toneBar = nil;
            [self end];
            
            return;
        }
    }
    
    if (perf > toneNode[toneStatus] && perf < toneNode[toneStatus]+5.0f) {
        
        if (volumn > 0.7) {
            
            rightInput = YES;
        }
    }
    else if (perf >= (toneNode[toneStatus]+5.0f) && perf <= (toneNode[toneStatus]+7.0f)) {
        
        if (!rightInput) {
            perf = 5;
            toneStatus = 0;
        }
        else {
            toneStatus ++;
            rightInput = false;
        }
    }
    else {
        
        if (volumn > 0.7) {
            toneStatus = 0;
            rightInput = false;
            perf = 5;
        }
    }
    
    toneBar.bar.percentage = perf;
}

-(void) start {
    
    [self setVisible:YES];
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:1 paused:NO];
}

-(void) end {
    
    [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:self];
    
    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    
    id action1 = [CCFadeIn actionWithDuration:0.1f];
    id action2 = [CCFadeIn actionWithDuration:0.1f];
    
    [rio.sprite runAction:[CCSequence actions:[CCRepeat actionWithAction:[CCSequence actions:action1, action2, nil] times:3], [CCCallBlock actionWithBlock:^{[[CCSharedData sharedData] refresh];[(CCLayerGame *)[[[CCDirector sharedDirector] runningScene] getChildByTag:0] end];}] ,nil]];
}

-(void) dealloc {
    
    [super dealloc];
}

@end
