//
//  CCElevator.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCElevator.h"


@implementation CCElevator


+(CCElevator *) spriteWithFileName:(NSString *)filename {
    
    CCElevator *obj = [[[CCElevator alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];

    obj->body = NULL;
    return obj;
}

-(id) init {
    
    if (self = [super init]) {
        
        status = WAITTING;
        [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:1 paused:NO];
    }
    
    return self;
}

-(void) updatePosition:(ccTime)dt {
    
    b2Vec2 posMeter = self->body->GetPosition();
    
    CGPoint posSprite = ccp(posMeter.x * PTM_RATIO, posMeter.y * PTM_RATIO);
    CGSize contentSize = [[self sprite] contentSize];
    posSprite.x += contentSize.width*0.5f;
    posSprite.y += contentSize.height*0.5f;
    [[self sprite] setPosition:posSprite];
}

-(void) update:(ccTime)dt {
    
    [self updatePosition:dt];
    
    CCRio *rio = (CCRio *)[[[CCSharedData sharedData] arr_rio] objectAtIndex:0];
    CGPoint rioPos = rio.sprite.position;
    
    if (status == WAITTING) {
    
        
        if (ccpDistance(rioPos, self.sprite.position) <= rio.sprite.contentSize.height*0.5f + self.sprite.contentSize.height*0.5f+3.0f) {
            status = UP;
        }
    }
    else if (status == UP) {
        
        b2Vec2 vel = self->body->GetLinearVelocity();
        if(self.sprite.position.y >= 754){

            vel.y = 0;
        }
        else
        {
            vel.y = 1;
        }
        
        self->body->SetLinearVelocity(vel);
    
        if (ccpSub(rioPos, self.sprite.position).x > (rio.contentSize.width*0.5f+self.sprite.contentSize.width*0.5f)) {
            status = TOP;
            
            
            if ([[[CCSharedData sharedData] arr_eagle] count] > 0) {
                CCEagle *eagle = [[[CCSharedData sharedData] arr_eagle] objectAtIndex:0];
                [eagle start];
            }
        }
    }
    else if (status == TOP) {
        
        if (ccpDistance(rioPos, self.sprite.position) <= rio.sprite.contentSize.height*0.5f + self.sprite.contentSize.height*0.5f+3.0f) {
            status = DOWN;
        }
    }
    else if (status == DOWN) {
       
        b2Vec2 vel = self->body->GetLinearVelocity();
        if(self.sprite.position.y <= -522){

            vel.y = 0;
        }
        else
        {
            vel.y = -1;
        }
        self->body->SetLinearVelocity(vel);
        
        if (ccpSub(rioPos, self.sprite.position).x > (rio.contentSize.width*0.5f+self.sprite.contentSize.width*0.5f)) {
            status = WAITTING;
        }
        
        
    }
}

-(void) dealloc {
    
    [super dealloc];
}

@end
