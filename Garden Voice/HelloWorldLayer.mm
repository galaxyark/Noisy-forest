//
//  CCLayerContent.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "CCSharedData.h"
#import "CCFloor.h"
#import "CCRio.h"
#import "CCAbilityBall.h"
#import "CCBoardObstacle.h"
#import "CCStoneObstacle.h"
#import "CCSmallAnimal.h"

#import "CCLayerControlPanel.h"
@implementation HelloWorldLayer

+(CCScene *) scene {
    
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    CCLayerControlPanel *layer1 = [CCLayerControlPanel node];
    [scene addChild:layer];
    [scene addChild:layer1];
    return scene;
}

-(id) init {
    
    if (self = [super init]) {
        
        world = [CCSharedData sharedData]->world;
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );

        world->SetDebugDraw(m_debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        //		flags += b2Draw::e_jointBit;
        //		flags += b2Draw::e_aabbBit;
        //		flags += b2Draw::e_pairBit;
        //		flags += b2Draw::e_centerOfMassBit;
        m_debugDraw->SetFlags(flags);
        
        //[[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"vg_physics.plist"];
        
        
        CCFloor *floor;
        bool physicsTest =true;
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_floor], floor) {
            
            if(physicsTest == false)
                [self addChild:[floor sprite] z:floor->z tag:floor->tag];
            
            
            /*******************************Add physics for background******************************/
            /*CCSprite* floorSprite = [floor sprite];
            b2BodyDef floor_bodyDef;
            floor_bodyDef.type = b2_staticBody;
            floor_bodyDef.position.Set((floorSprite.position.x - floorSprite.contentSize.width*0.5)/PTM_RATIO, (floorSprite.position.y-floorSprite.contentSize.height*0.5)/PTM_RATIO);
            b2Body* floorBody = world->CreateBody(&floor_bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:floorBody forShapeName:@"vg_4096_2048_BackGround"];
            */
        }
        
        CCRio *rio;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_rio], rio) {
            
            [self addChild:[rio sprite] z:rio->z tag:rio->tag];
            [rio runAnimation:@"walk_right"];
            
            /*******************************Add physics for background******************************/
            /*CCSprite* rioSprite = [rio sprite];
            b2BodyDef rio_bodyDef;
            rio_bodyDef.type = b2_dynamicBody;
            rio_bodyDef.position.Set((rioSprite.position.x - rioSprite.contentSize.width*0.5)/PTM_RATIO, (rioSprite.position.y-rioSprite.contentSize.height*0.5)/PTM_RATIO);
            b2Body* rioBody = world->CreateBody(&rio_bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:rioBody forShapeName:@"vg_96_128_Rio_Idle_Right"];*/
        }
        
        CCAbilityBall *tool;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_abilityBall], tool) {
            
            if(physicsTest == false)
                [self addChild:[tool sprite] z:tool->z tag:tool->tag];
        }
        
        CCBoardObstacle *board;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_boardObstacle], board) {
            
            if(physicsTest == false)
                [self addChild:[board sprite] z:board->z tag:board->tag];
            
            
            /*******************************Add physics for boards************************************/
            /*CCSprite* boardSprite = [board sprite];
            b2BodyDef board_bodyDef;
            board_bodyDef.type = b2_staticBody;
            board_bodyDef.position.Set((boardSprite.position.x - boardSprite.contentSize.width*0.5)/PTM_RATIO, (boardSprite.position.y-boardSprite.contentSize.height*0.5)/PTM_RATIO);
            b2Body* board_body = world->CreateBody(&board_bodyDef);
            if (board->tag==4)
                [[GB2ShapeCache sharedShapeCache] addFixturesToBody:board_body forShapeName:@"vg_128_96_board_1"];
            else
                [[GB2ShapeCache sharedShapeCache] addFixturesToBody:board_body forShapeName:@"vg_256_32_board_3"];*/
            
        }
        
        CCStoneObstacle *stone;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_stoneObstacle], stone) {
            
            if(physicsTest == false){
                [self addChild:[stone sprite] z:stone->z tag:stone->tag];
                [stone runAnimation:@"breaking"];
            }
            
            [self addChild:[stone sprite]];
            
            /*******************************Add physics for stone************************************/
            /*
            CCSprite* stoneSprite = [stone sprite];
            b2BodyDef stone_bodyDef;
            stone_bodyDef.type = b2_staticBody;
            stone_bodyDef.position.Set((stoneSprite.position.x - stoneSprite.contentSize.width*0.5)/PTM_RATIO, (stoneSprite.position.y-stoneSprite.contentSize.height*0.5)/PTM_RATIO);
            b2Body* stoneBody = world->CreateBody(&stone_bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:stoneBody forShapeName:@"vg_256_320_Rock_1"];*/
        }
        
        CCSmallAnimal *mole;
        
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_smallAnimal], mole) {
            
            if(physicsTest == false){
                [self addChild:[mole sprite] z:mole->z tag:mole->tag];
                [mole runAnimation:@"sleep_right"];
            }
        }
        
        [self scheduleUpdate];
    }
    
    return self;
}


-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}


-(void) update:(ccTime)dt {
    
    float cx, cy, cz;
    [[self camera] centerX:&cx centerY:&cy centerZ:&cz];
    cx += 0;
    
    [[self camera] setCenterX:cx centerY:-640 centerZ:cz];
    [[self camera] setEyeX:cx eyeY:-640 eyeZ:cz+1];
    
    
    /************************************Physics****************************************/
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
    world->Step(dt, velocityIterations, positionIterations);
}

-(void) dealloc {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [super dealloc];
}

@end
