//
//  CCMotionLessObject.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCMotionLessObject.h"


@implementation CCMotionLessObject
@synthesize isPhyEnable;

-(id) init {
    
    if (self = [super init]) {
        
        isPhyEnable = YES;
    }
    
    return self;
}

// set phyx enable/disable in future needs to
// check the phyenable to make object follow the physical world
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
