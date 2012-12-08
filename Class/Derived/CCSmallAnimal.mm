//
//  CCSmallAnimal.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSmallAnimal.h"
#import "CCFireBall.h"
#import "CCSharedData.h"

@implementation CCSmallAnimal
@synthesize d_anims;

+(CCSmallAnimal *) spriteWithFileName:(NSString *)filename {
    
    CCSmallAnimal *obj = [[[CCSmallAnimal alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    return obj;
}


-(id) init {
    
    if (self = [super init]) {
        
        self.d_anims = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}


-(void) loadAnimation:(NSString *)aname file:(NSString *)filename {
    
    if ([d_anims objectForKey:aname] == nil) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:filename];
        
        if ([filename hasSuffix:@".plist"]) {
            
            filename = [[CCFileUtils sharedFileUtils] removeSuffix:@".plist" fromPath:filename];
        }
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for (int i=1; i<5; i++) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%d.png", filename, i];
            [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.2];
        
        if ([aname isEqualToString:@"wakeup"]) {
            animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.3];
        }
        
        id action = [CCAnimate actionWithAnimation:animation];
        
        if ([aname isEqualToString:@"sleep_left"] || [aname isEqualToString:@"sleep_right"] ||
            [aname isEqualToString:@"attack_left"] || [aname isEqualToString:@"attack_right"]) {
            
            action = [CCRepeatForever actionWithAction:action];
        }
        
        if ([aname isEqualToString:@"run_right"]) {
            
            id moveTo = [CCMoveTo actionWithDuration:2.0f position:ccp(3584, 192)];
            id a_CallFunc = [CCCallFunc actionWithTarget:self selector:@selector(runAwayRight)];
            id anim = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:3];
            
            action = [CCSequence actions:[CCSpawn actions:moveTo, anim, nil], a_CallFunc, nil];
        }
        
        if ([aname isEqualToString:@"run_left"]) {
            

            id moveTo = [CCMoveTo actionWithDuration:2.0f position:ccp(2096, -448)];
            id a_CallFunc = [CCCallFunc actionWithTarget:self selector:@selector(runAwayLeft)];
            id anim = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:3];
            action = [CCSequence actions:[CCSpawn actions:moveTo, anim, nil], a_CallFunc, nil];
            
        }
        
        [d_anims setObject:action forKey:aname];
    }
    
}

-(void) runAnimation:(NSString *)aname {
    
    static NSString *animationName = nil;
    
    id action = [d_anims objectForKey:aname];
        
    if (action != nil && ![aname isEqualToString:animationName]) {
        
        [[self sprite] stopAllActions];
        [[self sprite] runAction:action];
        animationName = aname;
    }
}

-(id) getAnimationByName:(NSString *)aname {
    
    id action = [d_anims objectForKey:aname];
    if (action != nil) {
        
        return action;
    }
    return nil;
}

-(void) runAwayRight {

    CCFloor *floor;
    
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_floor], floor) {
        
        if ([floor->name isEqualToString:@"floor1"]) {
            
            [floor setVisible:NO];
            [floor setPhyEnable:NO];
            
            [[[CCSharedData sharedData] arr_dustbin] addObject:floor];
            [[[CCSharedData sharedData] arr_floor] removeObject:floor];
            
            break;
        }
    }
    
    CCSmallAnimal *mole;

    CCARRAY_FOREACH([[CCSharedData sharedData] arr_smallAnimal], mole) {
        
        if ([mole->name isEqualToString:@"attack"]) {
            
            [mole setVisible:YES];
            
            [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(attack:) forTarget:mole interval:1.5f paused:NO];
            [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:mole priority:1 paused:NO];
            [mole runAnimation:@"attack_right"];
            break;
        }
    }
    
    [self setVisible:NO];
    [[self sprite] removeFromParentAndCleanup:YES];
}

-(void) update:(ccTime)dt {
    
    CCRio *rio = [[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    if (rio.sprite.position.x - self.sprite.position.x >= 0) {
        
        [self runAnimation:@"attack_right"];
        direction = NO;
    }
    else {
        [self runAnimation:@"attack_left"];
        direction = YES;
    }
}

-(void) runAwayLeft {
    
    
    CCFloor *floor;
    
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_floor], floor) {
        
        if ([floor->name isEqualToString:@"floor2"]) {
            
            [floor setVisible:NO];
            [floor setPhyEnable:NO];
            
            [[[CCSharedData sharedData] arr_dustbin] addObject:floor];
            [[[CCSharedData sharedData] arr_floor] removeObject:floor];
            
            break;
        }
    }
    
    CCLargeAnimal *bmole;
    
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_largeAnimal], bmole) {
        
        if ([bmole->name isEqualToString:@"bigmole"]) {
            
            [bmole runAnimation:@"attack_right"];
            [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(attack:) forTarget:bmole interval:1.0f paused:NO];
            [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(defend:) forTarget:bmole interval:0.05f paused:NO];
        }
    }
    
    [self setVisible:NO];
    [self.sprite removeFromParentAndCleanup:YES];

}

-(void) attack:(ccTime)dt {
    
    CCFireBall *ball = nil;
    if (direction) {
        
        ball = [CCFireBall loadWithPlist:@"fireball.plist" name:@"stone" position:ccpSub(self.sprite.position, ccp(self.sprite.contentSize.width*0.5, 0.0))];
        
        ball->speed *= -1;
        ball->m_distance /= 2;
    }
    else {
        
        ball = [CCFireBall loadWithPlist:@"fireball.plist" name:@"stone" position:ccpAdd(self.sprite.position, ccp(self.sprite.contentSize.width*0.5, 0.0))];
    }
    
    [ball setVisible:YES];
    
    [[self.sprite parent] addChild:ball.sprite z:ball->z tag:ball->tag];
    
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:ball priority:0 paused:NO];
    
}

-(void) dealloc {
    
    [d_anims release];
    [super dealloc];
}


@end
