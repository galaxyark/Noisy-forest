//
//  CCLayerMenu.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayerMenu.h"
#import "CCBReader.h"
#import "CCLayerGame.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"

@implementation CCLayerMenu


+(CCScene *) scene {
    
    CCScene *scene = [CCBReader sceneWithNodeGraphFromFile:@"CCLayerMenu.ccbi" owner:self];
    
    return scene;
}

- (void) didLoadFromCCB {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    m_start = [CCMenuItemFont itemWithString:@"start" target:self selector:@selector(pressStart:)];
    m_start.fontName = @"Marker Felt";
    m_start.fontSize = 42;
    [m_start setPosition:ccp(winSize.width*0.5f, winSize.height*0.5f)];
    
    m_exit = [CCMenuItemFont itemWithString:@"exit" target:self selector:@selector(pressExit:)];
    
    m_exit.fontName = @"Marker Felt";
    m_exit.fontSize = 42;
    [m_exit setPosition:ccp(winSize.width*0.5f, winSize.height*0.5f - 100)];
    
    CCMenu *menu = [CCMenu menuWithItems:m_start, m_exit, nil];
    [menu setPosition:ccp(0, 0)];
    [self addChild:menu];
}
-(void) pressStart:(id)sender {

    id fadeIn = [CCFadeIn actionWithDuration:0.2f];
    id fadeOut = [CCFadeOut actionWithDuration:0.2f];
    
    id action = [CCRepeat actionWithAction:[CCSequence actions:fadeIn, fadeOut, nil] times:2];
    action = [CCSequence actions:action, [CCCallBlock actionWithBlock:^{
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[CCLayerGame scene]]];}], nil];
    
    [m_start runAction:action];
}

-(void) pressExit:(id)sender {
    
    exit(0);
}

@end
