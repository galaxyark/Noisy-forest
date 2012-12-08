//
//  CCLargeAnimal.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLargeAnimal.h"
#import "CCFireBall.h"

@implementation CCLargeAnimal

@synthesize d_anims;

+(CCLargeAnimal *) spriteWithFileName:(NSString *)filename {
    
    CCLargeAnimal *obj = [[[CCLargeAnimal alloc] init] autorelease];
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
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.5];
        id action = [CCAnimate actionWithAnimation:animation];
        
        if ([aname isEqualToString:@"attack_left"] || [aname isEqualToString:@"attack_right"]) {
            
            action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:animFrames delay:0.2]]];
        }
        else if ([aname isEqualToString:@"runaway"] || [aname isEqualToString:@"disappear"]) {
            
            action = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:animFrames delay:0.35f]];
        }
        
        [d_anims setObject:action forKey:aname];
    }
}

-(void) runAnimation:(NSString *)aname {
    
    id action = [d_anims objectForKey:aname];
    
    if (action != nil) {
        
        [[self sprite] stopAllActions];
        [[self sprite] runAction:action];
    }
    
}

-(id) getAnimationByName:(NSString *)aname {
    
    id anim = [d_anims objectForKey:aname];
    
    return anim;
    
}

-(void) attack:(ccTime)dt {
    
    CCFireBall *ball = [CCFireBall loadWithPlist:@"fireball.plist" name:@"fireball" position:ccpAdd(self.sprite.position, ccp(self.sprite.contentSize.width*0.5, 0.0))];
    
    [ball setVisible:YES];
    
    [[self.sprite parent] addChild:ball.sprite z:ball->z tag:ball->tag];
    
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:ball priority:0 paused:NO];
}

-(void) defend:(ccTime)dt {
    
    if (blood<=0) {
        
        [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(attack:) forTarget:self];

        id action1 = [self getAnimationByName:@"runaway"];
        id action2 = [self getAnimationByName:@"disappear"];
        [self.sprite stopAllActions];
        [self.sprite runAction:[CCSequence actions:action1, action2, [CCCallBlock actionWithBlock:^{[self setVisible:NO]; self->body->SetActive(false);}], nil]];
        
        [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(defend:) forTarget:self];
    }
}

-(void) dealloc {
    
    [self.d_anims release];
    [super dealloc];
}





@end
