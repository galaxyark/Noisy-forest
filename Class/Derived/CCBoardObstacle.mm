//
//  CCBoardObstacle.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCBoardObstacle.h"


@implementation CCBoardObstacle

+(CCBoardObstacle *) spriteWithFileName:(NSString *)filename {
    
    CCBoardObstacle *obj = [[[CCBoardObstacle alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    [obj setVisible:NO];
    
    obj->body = NULL;
    return obj;
}


-(id) init {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

-(void) dealloc {
    
    [super dealloc];
}


@end
