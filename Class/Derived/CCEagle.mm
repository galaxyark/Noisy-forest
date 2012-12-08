//
//  CCEagle.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCEagle.h"
#import "CCSharedData.h"
#import "CCBullet.h"
#import "CCNotation.h"

@implementation CCEagle
@synthesize d_anims;

+(CCEagle *) spriteWithFileName:(NSString *)filename {
    
    CCEagle *obj = [[[CCEagle alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    return obj;
}

-(id) init {
    
    if (self = [super init]) {
     
        self.d_anims = [[[NSMutableDictionary alloc] init] autorelease];
        status = EAGLEWANDER;
        direction = 1;
        baseSpeed = 100.0;
        bullets = 10;
        radius = 192.0f;
        speScalor = 3.0f;
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
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.2];
        id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
        
        [d_anims setObject:action forKey:name];
    }
    
}

-(void) runAnimation:(NSString *)name {
    
    static NSString *animation = nil;
    
    id action = [d_anims objectForKey:name];
    
    if (action != nil && ![name isEqualToString:animation]) {
        
        if (animation) {
            [animation release];
        }
        animation = [name retain];
        [[self sprite] stopAllActions];
        [[self sprite] runAction:action];
    }
    
}

-(void) start {
    
    static bool isStarted = NO;
    if (isStarted) {
        return;
    }
    isStarted = YES;
    [self setVisible:YES];
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:1 paused:NO];
}

-(void) update:(ccTime)dt {
    
    if (status == EAGLEWANDER) {
        
        [self wander:dt];
    }
    else if (status == EAGLEDIE) {
     
        [self die];
    }
    
    CCRio *rio = [[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    if (rio->bullets <= 0) {
        
        bullets = 10;
    }
}

-(void) wander:(ccTime)dt {
    
    static int time = 0;

    [self evaluate:dt];
    
    time+=1;
    
    CGPoint pos = self.sprite.position;
    
    CGPoint dest = ccpAdd(pos, ccp(speed*direction*dt, 0));
    
    if (dest.x > maxWidth) {
        
        direction *= -1;
        dest = ccpAdd(pos, ccp(speed*direction*dt, 0));
        
    }
    else if (dest.x < minWidth) {
        
        direction *= -1;
        dest = ccpAdd(pos, ccp(speed*direction*dt, 0));
    }
    [self setPosition:dest];
    if (direction>0) {
        [self runAnimation:@"fly_right"];
    }
    else {
        [self runAnimation:@"fly_left"];
    }
    
    
    if (bullets>0 && time%120 == 0) {
        
        time = 0;
        [self throwBullet];
        bullets--;
    }

}

-(void) throwBullet {
    
    CGPoint pos = self.sprite.position;
    CCBullet *bullet = [CCBullet spriteWithFileName:@"vg_48_48_Bird_Egg.png"];
    [bullet setXSpeed:speed*direction Y:0];
    [bullet setPosition:ccp(pos.x, pos.y - self.sprite.contentSize.height*0.5f)];
    bullet->status = PICKUP;
    [self.sprite.parent addChild:bullet.sprite];
    [bullet start];
}

-(void) getDamage {
    
    blood--;
    
    if (blood<= 0) {
        
        [self die];
    }
}

-(void) die {
    
    // Run animations here
    [[[CCSharedData sharedData] arr_eagle] removeObject:self];
    [[[CCSharedData sharedData] arr_dustbin] addObject:self];
    [self end];
}

-(void) evaluate:(ccTime)dt {
 
    float score = 10000.0f;
    int evalDirection = -2;
    CGPoint epos = self.sprite.position;
    CCBullet *bullet;
    float t_speed = baseSpeed*speScalor;
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_bullet], bullet) {
        
        if (bullet->status == ATTACK) {
            
            float xspe, yspe;
            [bullet getXSpeed:&xspe Y:&yspe];
            
            CGPoint bpos = bullet.sprite.position;
            if (ccpDistance(bpos, epos) > radius) {
                
                if (yspe < 0) {
                    bullet->status = PICKUP;
                }
                continue;
            }
            
            float time = 0.0f;
            float a, b, c, temp;
            
            float yOffset = epos.y - bpos.y;

            if (yOffset < 0) {
                
                if (yspe > 0) {
                    
                    time += 2*fabs(yspe)/fabs(bullet->yStep);
                }
                
                a = fabs(bullet->yStep);
                b = 2*fabs(yspe);
                c = -2*fabs(yOffset);
                temp = sqrt(pow(b, 2.0)-4*a*c);
                float t1 = (-b+temp)/(2*a);
                //float t2 = (-b-temp)/(2*a);
                time += t1;
            }
            else if (yOffset > 0) {
                
                if (yspe <= 0) {
                    
                    bullet->status = PICKUP;
                    continue;
                }
                else {
                    
                    a = fabsf(bullet->yStep);
                    b = -2*fabsf(yspe);
                    c = 2*fabsf(yOffset);
                    if (pow(b, 2.0) - 4*a*c < 0) {
                        continue;
                    }
                    temp = sqrt(pow(b, 2.0)-4*a*c);
                    float t1 = (-b+temp)/(2*a);
                    float t2 = (-b-temp)/(2*a);
                    
                    if (MIN(t1, t2) <= 0) {
                        
                        if (MAX(t1, t2) > 0) {
                            
                            time += MAX(t1, t2);
                        }
                    }
                    else {
                        time += MIN(t1, t2);
                    }
                    
                }
            }
            
            if (time>score || time <= 0) {
                continue;
            }
            score = time;
            
            float xOffset = time*xspe;
            
            float dis0 = fabs(epos.x - (bpos.x+xOffset));
            float dis1 = fabs(epos.x - t_speed*dt -(bpos.x+xOffset));
            float dis2 = fabs(epos.x + t_speed*dt -(bpos.x+xOffset));
            
            if (epos.x-t_speed*dt<minWidth) {
                dis1 = 0;
            }
            
            if (epos.x+t_speed*dt>maxWidth) {
                dis2 = 0;
            }
            
            if (dis0 > dis1) {
                
                if (dis0>dis2) {
                    
                    //stand still
                    evalDirection = 0;
                }
                else {
                    
                    // fly right
                    evalDirection = 1;
                    
                }
            }
            else {
                
                if (dis1>dis2) {
                    
                    // fly left
                    evalDirection = -1;
                }
                else {
                    
                    // fly right
                    evalDirection = 1;
                }
                
            }
            
        }
    }

    switch (evalDirection) {
        case 0:
            direction = 0;
            speed = baseSpeed;
            break;
        case -1:
            direction = -1;
            speed = t_speed;
            break;
        case 1:
            direction = 1;
            speed = t_speed;
            break;
        default:
            if (direction == 0) {
                direction = -1;
            }
            speed = baseSpeed;
            break;
    }
}

-(void) putAttackBullet:(ccTime)dt {
    
    CGPoint pos = [self.sprite position];
    
    CCBullet *bullet = [CCBullet spriteWithFileName:@"vg_48_48_Bird_Egg.png"];
    [bullet setXSpeed:100*direction Y:400];
    bullet->yStep = -300;
    bullet->status = ATTACK;
    [bullet setPosition:ccp(pos.x-100*direction, pos.y-200)];
    
    [self.sprite.parent addChild:bullet.sprite];
    [bullet start];
}

-(void) end {
    
    [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:self];
    
    
    CCNotation *notation = [CCNotation spriteWithFileName:@"vg_64_64_Musical_Notation.png"];
    
    [notation setPosition:ccp(3076, 860)];
    [self.sprite.parent addChild:notation.sprite];
    [notation start];

    id action1 = [CCFadeOut actionWithDuration:0.1f];
    id action2 = [CCFadeIn actionWithDuration:0.1f];
    
    id action = [CCRepeat actionWithAction:[CCSequence actions:action1, action2, nil] times:10];
    [self.sprite stopAllActions];
    [self.sprite runAction:[CCSequence actions:action, [CCCallBlock actionWithBlock:^{[self.sprite removeFromParentAndCleanup:YES];}], nil]];
}

-(void) dealloc {
    
    [super dealloc];
}


@end
