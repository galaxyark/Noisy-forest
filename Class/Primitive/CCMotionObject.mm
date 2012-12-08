//
//  CCMotionObject.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMotionObject.h"


@implementation CCMotionObject

@synthesize isPhyEnable;

-(id) init {
    
    if (self = [super init]) {

        isPhyEnable = YES;
    }
    
    return self;
}

-(void)setPhyEnable:(BOOL)enable{
    
    if (isPhyEnable == enable) {
        return;
    }
    
    isPhyEnable = enable;
    
    self->body->SetActive(isPhyEnable);
    
}


-(void) dealloc {
    
    [super dealloc];
}

@end
