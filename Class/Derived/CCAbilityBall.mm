//
//  CCAbilityBall.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCAbilityBall.h"


@implementation CCAbilityBall

+(CCAbilityBall *) spriteWithFileName:(NSString *)filename {
    
    CCAbilityBall *obj = [[[CCAbilityBall alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    return obj;
}

-(id) init {
    
    if (self = [super init]) {
     
        isInvoked = NO;
    }
    
    return self;
}

-(void) dealloc {
    
    [super dealloc];
}

@end
