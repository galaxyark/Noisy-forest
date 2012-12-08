//
//  CCLayerContent.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayerContent.h"
#import "CCSharedData.h"
#import "CCFloor.h"
#import "CCRio.h"
#import "CCAbilityBall.h"
#import "CCBoardObstacle.h"
#import "CCStoneObstacle.h"
#import "CCSmallAnimal.h"
#import "CCLargeAnimal.h"
#import "CCEagle.h"
#import "CCNotation.h"

@implementation CCLayerContent

+(CCScene *) scene {
    
    CCScene *scene = [CCScene node];
    CCLayerContent *layer = [CCLayerContent node];
    [scene addChild:layer];
    return scene;
}

-(id) init {
    
    if (self = [super init]) {
        
        CCFloor *floor;
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_floor], floor) {
            
            [self addChild:[floor sprite] z:floor->z tag:floor->tag];
        }
        
        CCRio *rio;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_rio], rio) {
            
            [self addChild:[rio sprite] z:rio->z tag:rio->tag];
            
        }
        
        CCAbilityBall *tool;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_abilityBall], tool) {
            
            [self addChild:[tool sprite] z:tool->z tag:tool->tag];
        }
        
        CCBoardObstacle *board;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_boardObstacle], board) {
            
            [self addChild:[board sprite] z:board->z tag:board->tag];
        }
        
        CCStoneObstacle *stone;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_stoneObstacle], stone) {
            
            [self addChild:[stone sprite] z:stone->z tag:stone->tag];
        }
        
        CCSmallAnimal *mole;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_smallAnimal], mole) {
            
            [self addChild:[mole sprite] z:mole->z tag:mole->tag];
            if ([mole->name isEqualToString:@"mole"]) {
                [mole runAnimation:@"sleep_left"];
            }
        }
        
        CCLargeAnimal *bmole;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_largeAnimal], bmole) {
            
            [self addChild:[bmole sprite] z:bmole->z tag:bmole->tag];
        }
        
        CCEagle *eagle;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_eagle], eagle) {
            
            [self addChild:[eagle sprite] z:eagle->z tag:eagle->tag];
            [eagle runAnimation:@"fly_right"];
        }
        
        CCElevator *elev;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_elevator], elev) {
            
            [self addChild:[elev sprite] z:elev->z tag:elev->tag];
        }
        
        world = [CCSharedData sharedData]->world;
        [self scheduleUpdate];
        
    }
    
    return self;
}

-(void) updateCamera:(ccTime)dt {
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CCSprite *sprite = (CCSprite *)[self getChildByTag:1];
    CGPoint spritePos = [sprite position];
    
    CGPoint camPos;
    float z;
    [[self camera] centerX:&camPos.x centerY:&camPos.y centerZ:&z];
    
    if (spritePos.x - camPos.x >= s.width*0.5f && camPos.x <= 3072) {
        camPos.x = spritePos.x - s.width*0.5f;
    }
    else if (spritePos.x - camPos.x <= s.width*0.25f && camPos.x >= 0) {
        camPos.x = spritePos.x - 256;
    }
    
    if (spritePos.y - camPos.y >= s.height*0.5f && camPos.y <= 620.0f) {
        camPos.y = spritePos.y - s.height*0.5f;
    }
    else if (spritePos.y - camPos.y <= 192 && camPos.y >= -640.0f) {
        camPos.y = spritePos.y - 192.0f;
    }
    
    if (camPos.x>=3072.0f) {
        camPos.x = 3072.0f;
    }
    else if (camPos.x<=0) {
        camPos.x = 0;
    }
    
    if (camPos.y<=-640.0f) {
        camPos.y = -640.0f;
    }
    else if (camPos.y>=620.0f) {
        camPos.y = 620.0f;
    }
    
    [[self camera] setCenterX:camPos.x centerY:camPos.y centerZ:0];
    [[self camera] setEyeX:camPos.x eyeY:camPos.y eyeZ:1];

}

-(void) update:(ccTime)dt {
 
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    [self updateCamera:dt];
}

-(void) dealloc {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [super dealloc];
}

@end
