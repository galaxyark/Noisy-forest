//
//  CCRio.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMotionObject.h"
#import "CCAbilityBall.h"
#import "powerbar.h"

@interface CCRio : CCMotionObject <PANIMATION, CCTargetedTouchDelegate> {
    
    @public
    CCAbilityBall *activeTool;
    CCArray *tools;
    @public
    int bullets;
    
    @private
    CGPoint shotpos;
    BOOL isTouchEnable;
    
    PowerBar *copterBar;
    PowerBar *loudspeakerBar;
    PowerBar *shieldBar;
    PowerBar *crossbowBar;
    
    int m_face;
}

+(CCRio *) spriteWithFileName:(NSString *)filename;
-(void) updatePosition:(ccTime)dt;
-(void) updateTools:(ccTime)dt;
-(void) updateMove:(ccTime)dt;
-(void) update:(ccTime)dt;
-(void) copter;
-(void) loudSpeaker;
-(void) shield:(ccTime)dt;


@end
