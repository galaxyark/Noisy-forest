//
//  CCLayerGame.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayerGame.h"
#import "HelloWorldLayer.h"
#import "CCLayerMenu.h"

@implementation CCLayerGame

@synthesize content, control;

+(CCScene *) scene {
    
    CCScene *scene = [CCScene node];
    CCLayerGame *layer = [CCLayerGame node];
    [scene addChild:layer z:-1 tag:0];
    return scene;
}

-(id) init {
    
    if (self = [super init]) {
        
        control = [CCLayerControlPanel sharedController];
        content = [CCLayerContent node];
        [self addChild:content z:0];
        [self addChild:control z:1];
        
    }
    
    return self;
}

-(void) end {
    
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [[CCLayerControlPanel sharedController] refresh];
    [[CCDirector sharedDirector] replaceScene:[CCLayerMenu scene]];
}


@end
