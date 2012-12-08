//
//  CCFireBall.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCFireBall.h"
#import "CCSharedData.h"
#import "MicrophoneController.h"


@implementation CCFireBall

+(CCFireBall *) spriteWithFileName:(NSString *)filename {
    
    CCFireBall *obj = [[[CCFireBall alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    
    return obj;
}

+(CCFireBall *) loadWithPlist:(NSString *)plist name:(NSString *)name position:(CGPoint)position {
    
    CCFireBall *ball = nil;
    
    NSString *root = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@", root, plist];
    NSMutableDictionary *temp = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSEnumerator *enumerator = [temp keyEnumerator];
    while (id key = [enumerator nextObject]) {
        
        NSDictionary *dic = [temp objectForKey:key];
        
        NSString *m_name = (NSString *)[dic objectForKey:@"name"];
        if (![m_name isEqualToString:name]) {
            continue;
        }
        
        NSString *s_filename = (NSString *)[dic objectForKey:@"filename"];
        NSNumber *width = (NSNumber *)[dic objectForKey:@"width"];
        NSNumber *z = (NSNumber *)[dic objectForKey:@"z"];
        NSNumber *tag = (NSNumber *)[dic objectForKey:@"tag"];
        NSNumber *y = (NSNumber *)[dic objectForKey:@"y"];
        NSNumber *dis = (NSNumber *)[dic objectForKey:@"distance"];
        NSNumber *spe = (NSNumber *)[dic objectForKey:@"speed"];
        NSNumber *pow = (NSNumber *)[dic objectForKey:@"power"];
        
        ball = [CCFireBall spriteWithFileName:s_filename];
        ball->z = z.intValue;
        ball->tag = tag.intValue;
        ball->oriY = y.intValue;
        ball->m_distance = dis.intValue;
        ball->speed = spe.intValue;
        ball->power = pow.floatValue;
        [ball setPosition:ccp(position.x+width.intValue*0.5f, ball->oriY)];
    }
    
    return ball;
}

-(void) update:(ccTime)dt {
    
    if (fabs(distance)>=fabs(m_distance)) {
        
        [self destory];
        return;
    }
    
    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    CCLargeAnimal *bmole = (CCLargeAnimal *)[[[CCSharedData sharedData] arr_largeAnimal] objectAtIndex:0];
    assert(rio != nil);
    assert(bmole != nil);
    
    if ([self isVisualCollideWith:rio radius:self.sprite.contentSize.width*0.5f]) {
        
        if ([rio->activeTool->name isEqualToString:@"shield"] && rio->activeTool->isInvoked) {
            
                speed *= -2.0;
                m_distance = -(distance+256);
                distance = 0;
                CGPoint pos = [self.sprite position];
                pos.y = -640+128+128;
                [self setPosition:pos];
                
        }
        else {
            
            rio->body->ApplyLinearImpulse(b2Vec2(power*speed/fabs(speed), 0.0), rio->body->GetWorldCenter());
            [self destory];
        }
    }
    else if ([self isVisualCollideWith:bmole radius:self.sprite.contentSize.width]) {
    
        bmole->blood--;
        [self destory];
    }
    else {
        
        CGPoint position = [self.sprite position];
        position.x += speed*dt;
        [self setPosition:position];
        distance += speed*dt;
    }
}

-(void) destory {
    
    [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:self];
    [self setVisible:NO];
    [self.sprite removeFromParentAndCleanup:YES];
}

-(id) init {
    
    if (self = [super init]) {
        
        distance = 0.0f;

    }
    
    return self;
}


-(void) dealloc {
    
    [super dealloc];
}


@end
