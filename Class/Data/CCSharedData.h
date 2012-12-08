//
//  CCSharedData.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#import "CCFloor.h"
#import "CCRio.h"
#import "CCAbilityBall.h"
#import "CCBoardObstacle.h"
#import "CCStoneObstacle.h"
#import "CCSmallAnimal.h"
#import "CCLargeAnimal.h"
#import "CCEagle.h"
#import "CCElevator.h"

#define PTM_RATIO 128.0f

@interface CCSharedData : NSObject {
    
    @public
    b2World *world;
    BOOL isReady;
}

@property (atomic, assign) CCArray *arr_rio;
@property (atomic, assign) CCArray *arr_abilityBall;
@property (atomic, assign) CCArray *arr_floor;
@property (atomic, assign) CCArray *arr_boardObstacle;
@property (atomic, assign) CCArray *arr_stoneObstacle;
@property (atomic, assign) CCArray *arr_smallAnimal;
@property (atomic, assign) CCArray *arr_largeAnimal;
@property (atomic, assign) CCArray *arr_dustbin;
@property (atomic, assign) CCArray *arr_eagle;
@property (atomic, assign) CCArray *arr_bullet;
@property (atomic, assign) CCArray *arr_elevator;

+(CCSharedData *)sharedData;
-(void) initPhysics;
-(void) loadResource;
-(void) loadRio:(NSString *)plist;
-(void) loadAbilityBall:(NSString *)plist;
-(void) loadFloor:(NSString *)plist;
-(void) loadBoardObstacle:(NSString *)plist;
-(void) loadStoneObstacle:(NSString *)plist;
-(void) loadSmallAnimal:(NSString *)plist;
-(void) loadLargeAnimal:(NSString *)plist;
-(void) loadEagle:(NSString *)plist;
-(void) loadElevator:(NSString *)plist;
-(void) refresh;

@end
