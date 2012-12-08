//
//  SkillPanelBase.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SkillPanelBase.h"
#import "CCAbilityBall.h"
#import "CCSharedData.h"
#import "CCRio.h"
#import "MicrophoneController.h"
#define RADIUS 100.0f

@implementation SkillPanelBase

-(id) init {
    
    if (self = [super init]) {
        
        oriPos = ccp(900, 80);
        
        tools = [[CCArray alloc] init];
        
        CCAbilityBall *ball = [CCAbilityBall spriteWithFileName:@"vg_64_64_tool_0.png"];
        [ball setVisible:YES];
        [[ball sprite] setScale:1.5f];
        [self addChild:ball.sprite];
        [tools addObject:ball];
        
        flag = 0;
        
        [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:2 paused:NO];
    }
    
    return self;
}

-(void) onEnterTransitionDidFinish {
    
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL)isTouchedOnBall:(CGPoint)ballPos touchPos:(CGPoint)touchPos radius:(float)r {
    
    if (ccpDistance(ballPos, touchPos)<=r) {
        
        return YES;
    }
    
    return NO;
}

-(void) addTool: (CCAbilityBall *)ball {

    if ([tools containsObject:ball]) {
        
        return;
    }
    else {
        
        [ball setVisible:NO];
        [ball setPosition:ccp(0, 0)];
        [ball.sprite setScale:1.5f];
        [self addChild:ball.sprite];
        [tools addObject:ball];
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pt = [self convertTouchToNodeSpace:touch];

    if (flag == 0) {
    
        CCAbilityBall *ball = (CCAbilityBall *)[tools objectAtIndex:0];
        
        if (ccpDistance(pt, ccp(0, 0))<ball.sprite.contentSize.width*ball.sprite.scaleX/2.0) {
            
            for (int i=0; i<tools.count; i++) {
                
                CCAbilityBall *curBall = (CCAbilityBall *)[tools objectAtIndex:i];
                CGPoint dest = ccp(0.0f, 0.0f);
                dest.y = i*RADIUS;
                /*switch (i) {
                    case 1:
                        dest = ccp(-RADIUS, 0.0f);
                        break;
                    case 2:
                        dest = ccp(-RADIUS/2.0, RADIUS*1.732/2.0);
                        break;
                    case 3:
                        dest = ccp(RADIUS/2.0, RADIUS*1.732/2.0);
                        break;
                    case 4:
                        dest = ccp(RADIUS, 0.0f);
                        break;
                    default:
                        break;
                }*/

                
                
                id move = [CCMoveBy actionWithDuration:0.1f position:dest];
                [curBall setVisible:YES];
                [curBall.sprite runAction:move];
            
            }
            
            flag = 1;
        }
    }
    else if (flag == 1) {
        
        int theBall = -1;
        
        for (int i=0; i<tools.count; i++) {
            
            CCAbilityBall *ball = (CCAbilityBall *)[tools objectAtIndex:i];
            if ([self isTouchedOnBall: ball.sprite.position touchPos:pt radius:ball.sprite.contentSize.width/2.0]) {
                
                theBall = i;
                break;
            }
        }
        
        if (theBall != -1) {
            
            for (int i=0; i<tools.count; i++) {
                
                CCAbilityBall *ball = (CCAbilityBall *)[tools objectAtIndex:i];

                id move = [CCMoveTo actionWithDuration:0.1f position:ccp(0.0, 0.0)];
                
                [ball.sprite runAction:move];

                if (i == theBall) {
            
                    [ball setVisible:YES];
                    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
                    rio->activeTool = ball;
                    rio->activeTool->isInvoked = NO;
                }
                else {
                    [ball setVisible:NO];
                }
            }
            
            if (theBall == 1 || theBall == 2) {
                
                [[MicrophoneController sharedInstance] startDetecting];
                [[MicrophoneController sharedInstance] stopFrequency];
            }
            else if (theBall == 3) {
                
                [[MicrophoneController sharedInstance] stopDetecting];
                [[MicrophoneController sharedInstance] startFrenquency];
            }
            else if (theBall == 4) {
            
                [[MicrophoneController sharedInstance] startDetecting];
                [[MicrophoneController sharedInstance] stopFrequency];
            }
            else {
                
                [[MicrophoneController sharedInstance] stopDetecting];
                [[MicrophoneController sharedInstance] stopFrequency];
            }
            flag = 0;
            
        }
        else {
            [[MicrophoneController sharedInstance] stopDetecting];
            [[MicrophoneController sharedInstance] stopFrequency];
        }
        

    }
    return NO;

}

-(void) update:(ccTime)dt {

    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    
    if ([rio->tools count] > 0) {
        
        for (int i=0; i<rio->tools.count; i++) {
            
            CCAbilityBall *ball = (CCAbilityBall *)[rio->tools objectAtIndex:i];
            [self addTool:ball];
            [rio->tools removeObject:ball];
        }
    }
}

- (void) onExit {
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(void) dealloc {
    
    
    [tools release];
    [super dealloc];
}

@end
