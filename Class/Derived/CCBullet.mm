//
//  CCBullet.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCBullet.h"
#import "CCSharedData.h"


@implementation CCBullet

+(CCBullet *) spriteWithFileName:(NSString *)filename {
    
    CCBullet *obj = [[[CCBullet alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    obj->width = obj.sprite.contentSize.width;
    obj->height = obj.sprite.contentSize.height;
    
    return obj;
}


-(id) init {
    
    if (self = [super init]) {
        
        yStep = -300;
    }
    
    return self;
}

-(void) setXSpeed:(float)x Y:(float)y {
    
    xSpeed = x;
    ySpeed = y;
}

-(void) getXSpeed:(float *)x Y:(float *)y {
    
    *x = xSpeed;
    *y = ySpeed;
}

-(void) update:(ccTime)dt {
    
    CGPoint pos = self.sprite.position;
    ySpeed += dt*yStep;
    pos.x += xSpeed*dt;
    pos.y += ySpeed*dt;
    [self setPosition:pos];

    if (pos.x+width*0.5f>4096 || pos.x-width*0.5f<0) {
        
        [self end];
    }
    if (pos.y+height*0.5>2048 || pos.y-height*0.5f<784) {
        
        [self end];
    }
    
    [self collideCheck];
}

-(void) collideCheck {
    
    if (status == ATTACK) {
        
        CCEagle *eagle = nil;
        
        if ([[CCSharedData sharedData] arr_eagle].count > 0) {
            
            eagle = [[[CCSharedData sharedData] arr_eagle] objectAtIndex:0];
        }
        
        
        if (eagle && [self isVisualCollideWith:eagle radius: width*1.5f]) {
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"-1" fontName:@"Arial" fontSize:64];
            [label setColor:ccRED];
            [label setPosition:ccp(self.sprite.contentSize.width*0.5f, self.sprite.contentSize.height*0.5f)];
            [eagle.sprite addChild:label z:3];
            
            id move = [CCMoveBy actionWithDuration:1.0f position:ccp(100, 100)];
            id appear = [CCFadeOut actionWithDuration:0.5f];
            id action = [CCSequence actions:[CCEaseBounceOut actionWithAction:move], appear, [CCCallBlock actionWithBlock:^{[label setVisible:NO];[label removeFromParentAndCleanup:YES];}], nil];
            [label runAction:action];
            
            [eagle getDamage];
            [self end];
            
            return;
        }
    }
    else if (status == PICKUP) {
    
    
        CCRio *rio = [[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    
        if ([self isVisualCollideWith:rio radius:width]) {
    
            rio->bullets++;
            [self end];
            CCLabelTTF *label = [CCLabelTTF labelWithString:@"+1" fontName:@"Arial" fontSize:48];
            [label setPosition:ccp(rio.sprite.contentSize.width*0.5f, rio.sprite.contentSize.height*0.5f)];
            [label setColor:ccMAGENTA];
            [rio.sprite addChild:label];
            id move = [CCMoveBy actionWithDuration:1.0f position:ccp(50, 50)];
            id appear = [CCFadeOut actionWithDuration:0.5f];
            id action = [CCSequence actions:[CCEaseBackOut actionWithAction:move], appear, [CCCallBlock actionWithBlock:^{[label setVisible:NO];[label removeFromParentAndCleanup:YES];}], nil];
            [label runAction:action];
        
            return;
        }
    }
    
    CCBullet *bullet;
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_bullet], bullet) {
        
        if (self != bullet) {
            
            if ([self isVisualCollideWith:bullet radius:width]) {
                [self end];
                [bullet end];
            }
        }
    }
    
    
}

-(void) start {
    
    [[[CCSharedData sharedData] arr_bullet] addObject:self];
    [self setVisible:YES];
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:0 paused:NO];
}

-(void) end {
    
    [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:self];
    [self setVisible:NO];
    [self.sprite removeFromParentAndCleanup:YES];
    [[[CCSharedData sharedData] arr_bullet] removeObject:self];
}

-(void) dealloc {
    
    [super dealloc];
}


@end
