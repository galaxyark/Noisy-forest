//
//  CCSharedData.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSharedData.h"

#import "GB2ShapeCache.h"
#import "CCLayerMenu.h"
static CCSharedData *data;

@implementation CCSharedData
@synthesize arr_rio;
@synthesize arr_abilityBall;
@synthesize arr_floor;
@synthesize arr_boardObstacle;
@synthesize arr_stoneObstacle;
@synthesize arr_smallAnimal;
@synthesize arr_largeAnimal;
@synthesize arr_dustbin;
@synthesize arr_eagle;
@synthesize arr_bullet;
@synthesize arr_elevator;

+(CCSharedData *)sharedData {
    
    if (data == nil) {
        data = [[CCSharedData alloc] init];
    }
    
    return data;
}

-(id) init {
    
    if (self = [super init]) {
        
        isReady = NO;
        arr_abilityBall = [[CCArray alloc] init];
        arr_floor = [[CCArray alloc] init];
        arr_boardObstacle = [[CCArray alloc] init];
        arr_stoneObstacle = [[CCArray alloc] init];
        arr_smallAnimal = [[CCArray alloc] init];
        arr_largeAnimal = [[CCArray alloc] init];
        arr_eagle = [[CCArray alloc] init];
        arr_bullet = [[CCArray alloc] init];
        arr_dustbin = [[CCArray alloc] init];
        arr_rio = [[CCArray alloc] init];
        arr_elevator = [[CCArray alloc] init];
        
        [self initPhysics];
        [self loadResource];
        isReady = YES;
    }
    
    return self;
}

-(void) initPhysics {
    
    b2Vec2 gravity;
    gravity.Set(0.0f, -9.8f);
    
    world = new b2World(gravity);
    
    world->SetAllowSleeping(true);
    
    world->SetContinuousPhysics(true);
    
}

-(void) loadResource {
    
    [self loadAbilityBall:@"abilityball.plist"];
    [self loadFloor:@"floor.plist"];
    [self loadBoardObstacle:@"boardobstacle.plist"];
    [self loadStoneObstacle:@"stoneobstacle.plist"];
    [self loadSmallAnimal:@"smallanimal.plist"];
    [self loadLargeAnimal:@"biganimal.plist"];
    [self loadEagle:@"eagle.plist"];
    [self loadElevator:@"elevator.plist"];
    [self loadRio:@"rio.plist"];
}

-(void) loadRio:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = [temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *isPhyxEnable = (NSNumber *)[dic objectForKey:@"isPhyxEnable"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSDictionary *animDic = [dic objectForKey:@"animations"];
        
        
        CCRio *rio = [CCRio spriteWithFileName:s_filename];
        [rio setPosition:ccp(x.intValue, y.intValue)];
        [rio setVisible:[isVisible boolValue]];
        rio->z = z.intValue;
        rio->tag = tag.intValue;
        NSArray *keys = [animDic allKeys];
        for (int i=0; i<keys.count; i++) {
        
            [rio loadAnimation:[keys objectAtIndex:i] file:[animDic objectForKey:[keys objectAtIndex:i]]];
        }
        
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            
            NSString *phyfile = (NSString *)[dic objectForKey:@"phyfile"];
            NSString *bodyname = (NSString *)[dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            bodyDef.fixedRotation = true;
            bodyDef.position.Set((x.intValue - width.intValue*0.5f)/PTM_RATIO, (y.intValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = rio;
            
            rio->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:rio->body forShapeName:bodyname];
            
            [rio setPhyEnable:YES];
        }
        
        [arr_rio addObject:rio];
    }
}

-(void) loadAbilityBall:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSString *name = (NSString *)[dic objectForKey:@"name"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        
        CCAbilityBall *tool = [CCAbilityBall spriteWithFileName:s_filename];
        [tool setPosition:ccp(x.intValue, y.intValue)];
        [tool setVisible:isVisible.boolValue];
        tool->z = z.intValue;
        tool->tag = tag.intValue;
        tool->name = [name retain];
        
        [arr_abilityBall addObject:tool];
    }
    
}

-(void) loadFloor:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSString *name = (NSString *)[dic objectForKey:@"name"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSNumber *isPhyxEnable = (NSNumber *)[dic objectForKey:@"isPhyxEnable"];
        
        
        CCFloor *floor = [CCFloor spriteWithFileName:s_filename];
        [floor setPosition:ccp(x.intValue, y.intValue)];
        [floor setVisible:[isVisible boolValue]];
        floor->name = [name retain];
        floor->z = z.intValue;
        floor->tag = tag.intValue;
        
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            NSString *phyfile = [dic objectForKey:@"phyfile"];
            NSString *bodyname = [dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_staticBody;
            bodyDef.position.Set((x.intValue - width.intValue*0.5f)/PTM_RATIO, (y.intValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = floor;
            
            floor->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:floor->body forShapeName:bodyname];
            
            [floor setPhyEnable:YES];
            
        }
        
        [arr_floor addObject:floor];
        
    }
    
}

-(void) loadBoardObstacle:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSNumber *isPhyxEnable = (NSNumber *)[dic objectForKey:@"isPhyxEnable"];
        
        CCBoardObstacle *bob = [CCBoardObstacle spriteWithFileName:s_filename];
        [bob setPosition:ccp(x.intValue, y.intValue)];
        [bob setVisible:[isVisible boolValue]];
        bob->z = z.intValue;
        bob->tag = tag.intValue;
        
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            NSString *phyfile = (NSString *)[dic objectForKey:@"phyfile"];
            NSString *bodyname = (NSString *)[dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_kinematicBody;
            bodyDef.position.Set((x.intValue - width.intValue*0.5f)/PTM_RATIO, (y.intValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = bob;
            
            bob->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:bob->body forShapeName:bodyname];
            
            [bob setPhyEnable:YES];
        }
        
        [arr_boardObstacle addObject:bob];
            
    }
    
}

-(void) loadStoneObstacle:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSDictionary *animDic = [dic objectForKey:@"animations"];
        NSNumber *isPhyxEnable = [dic objectForKey:@"isPhyxEnable"];
        
        CCStoneObstacle *stone = [CCStoneObstacle spriteWithFileName:s_filename];
        [stone setPosition:ccp(x.intValue, y.intValue)];
        [stone setVisible:isVisible.boolValue];
        stone->z = z.intValue;
        stone->tag = tag.intValue;
        NSArray *keys = [animDic allKeys];
        for (int i=0; i<keys.count; i++) {
            [stone loadAnimation:[keys objectAtIndex:i] file:[animDic objectForKey:[keys objectAtIndex:i]]];
        }
        
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            NSString *phyfile = (NSString *)[dic objectForKey:@"phyfile"];
            NSString *bodyname = (NSString *)[dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_kinematicBody;
            bodyDef.position.Set((x.floatValue - width.intValue*0.5f)/PTM_RATIO, (y.floatValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = stone;
            
            stone->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:stone->body forShapeName:bodyname];
            
            [stone setPhyEnable:YES];
        }
        
        [arr_stoneObstacle addObject:stone];
    }
    
}

-(void) loadSmallAnimal:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = [temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSString *name = (NSString *)[dic objectForKey:@"name"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSDictionary *animDic = [dic objectForKey:@"animations"];
        
        
        CCSmallAnimal *mole = [CCSmallAnimal spriteWithFileName:s_filename];
        [mole setPosition:ccp(x.intValue, y.intValue)];
        [mole setVisible:[isVisible boolValue]];
        mole->name = [name retain];
        mole->z = z.intValue;
        mole->tag = tag.intValue;
       
        NSArray *keys = [animDic allKeys];
        for (int i=0; i<keys.count; i++) {
            [mole loadAnimation:[keys objectAtIndex:i] file:[animDic objectForKey:[keys objectAtIndex:i]]];
        }
        
        [arr_smallAnimal addObject:mole];
    }

    
}

-(void) loadLargeAnimal:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = [temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *isPhyxEnable = (NSNumber *)[dic objectForKey:@"isPhyxEnable"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSString *name = (NSString *)[dic objectForKey:@"name"];
        NSDictionary *animDic = [dic objectForKey:@"animations"];
        NSNumber *blood = (NSNumber *)[dic objectForKey:@"blood"];
        
        CCLargeAnimal *bmole = [CCLargeAnimal spriteWithFileName:s_filename];
        [bmole setPosition:ccp(x.intValue, y.intValue)];
        [bmole setVisible:[isVisible boolValue]];
        bmole->name = [name retain];
        bmole->z = z.intValue;
        bmole->tag = tag.intValue;
        bmole->blood = blood.intValue;
        
        NSArray *keys = [animDic allKeys];
        for (int i=0; i<keys.count; i++) {
            
            [bmole loadAnimation:[keys objectAtIndex:i] file:[animDic objectForKey:[keys objectAtIndex:i]]];
        }
        
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            
            NSString *phyfile = (NSString *)[dic objectForKey:@"phyfile"];
            NSString *bodyname = (NSString *)[dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            bodyDef.fixedRotation = true;
            bodyDef.position.Set((x.intValue - width.intValue*0.5f)/PTM_RATIO, (y.intValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = bmole;
            
            bmole->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:bmole->body forShapeName:bodyname];
            
            [bmole setPhyEnable:YES];
        }
        
        [arr_largeAnimal addObject:bmole];
    }
    
}

-(void) loadEagle:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSNumber *minWidth = (NSNumber *)[dic objectForKey:@"minWidth"];
        NSNumber *maxWidth = (NSNumber *)[dic objectForKey:@"maxWidth"];
        NSNumber *blood = (NSNumber *)[dic objectForKey:@"blood"];
        NSDictionary *animDic = [dic objectForKey:@"animations"];
        
        CCEagle *eagle = [CCEagle spriteWithFileName:s_filename];
        [eagle setPosition:ccp(x.intValue, y.intValue)];
        [eagle setVisible:isVisible.boolValue];
        eagle->z = z.intValue;
        eagle->tag = tag.intValue;
        eagle->minWidth = minWidth.floatValue;
        eagle->maxWidth = maxWidth.floatValue;
        eagle->blood = blood.intValue;
        NSArray *keys = [animDic allKeys];
        for (int i=0; i<keys.count; i++) {
            [eagle loadAnimation:[keys objectAtIndex:i] file:[animDic objectForKey:[keys objectAtIndex:i]]];
        }
        
        [arr_eagle addObject:eagle];
    }
}

-(void) loadElevator:(NSString *)plist {
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = (NSDictionary *)[temp objectForKey:key];
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *x = (NSNumber *)[dic objectForKey:@"x"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *isVisible = (NSNumber *)[dic objectForKey:@"isVisible"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSNumber *isPhyxEnable = [dic objectForKey:@"isPhyxEnable"];
        
        CCElevator *elev = [CCElevator spriteWithFileName:s_filename];
        [elev setPosition:ccp(x.intValue, y.intValue)];
        [elev setVisible:isVisible.boolValue];
        elev->z = z.intValue;
        elev->tag = tag.intValue;
    
        if (isPhyxEnable.boolValue) {
            
            NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
            NSNumber *height = (NSNumber *)[dic objectForKey:@"height"];
            NSString *phyfile = (NSString *)[dic objectForKey:@"phyfile"];
            NSString *bodyname = (NSString *)[dic objectForKey:@"bodyname"];
            [[GB2ShapeCache sharedShapeCache] addShapesWithFile:phyfile];
            
            b2BodyDef bodyDef;
            bodyDef.type = b2_kinematicBody;
            bodyDef.position.Set((x.floatValue - width.intValue*0.5f)/PTM_RATIO, (y.floatValue - height.intValue*0.5f)/PTM_RATIO);
            bodyDef.userData = elev;
            
            elev->body = world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:elev->body forShapeName:bodyname];
            
            [elev setPhyEnable:YES];
        }
        
        [arr_elevator addObject:elev];
    }
}

-(void) refresh {
    
    if (!data) {
    
        [data release];
    }
    
    data = nil;
}

-(void) dealloc {
    
    [arr_rio release];
    [arr_abilityBall release];
    [arr_floor release];
    [arr_boardObstacle release];
    [arr_stoneObstacle release];
    [arr_smallAnimal release];
    [arr_largeAnimal release];
    [arr_eagle release];
    [arr_bullet release];
    [arr_elevator release];
    [arr_dustbin release];
    [super dealloc];
}

@end
