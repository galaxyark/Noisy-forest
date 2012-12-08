//
//  CCStoneObstacle.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCStoneObstacle.h"


@implementation CCStoneObstacle
@synthesize d_anims;

+(CCStoneObstacle *) spriteWithFileName:(NSString *)filename {
    
    CCStoneObstacle *obj = [[[CCStoneObstacle alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    obj->body = NULL;
    return obj;
}


-(id) init {
    
    if (self = [super init]) {
        
        self.d_anims = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}


-(void) loadAnimation:(NSString *)name file:(NSString *)filename {
    
    if ([d_anims objectForKey:name] == nil) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:filename];
        
        if ([filename hasSuffix:@".plist"]) {
            filename = [[CCFileUtils sharedFileUtils] removeSuffix:@".plist" fromPath:filename];
        }
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for (int i=1; i<5; i++) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%d.png", filename, i];
            [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:1.0f];
        id action = [CCAnimate actionWithAnimation:animation];
        
        if ([name isEqualToString:@"breaking"]) {
            
            id a_CallBack = [CCCallFunc actionWithTarget:self selector:@selector(breaking)];
            
            action = [CCSequence actions:action, a_CallBack, nil];
            
        }
        
        [d_anims setObject:action forKey:name];
        
    }
    
}

-(void) runAnimation:(NSString *)name {
    
    id action = [d_anims objectForKey:name];
    
    if (action != nil) {
        
        [[self sprite] stopAllActions];
        [[self sprite] runAction:action];
    }
}

-(void) breaking {
    
    [self setPhyEnable:NO];
}

-(void) dealloc {
    
    [self.d_anims release];
    [super dealloc];
}


@end
