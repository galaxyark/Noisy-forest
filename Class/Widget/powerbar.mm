//
//  powerbar.m
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "powerbar.h"


@implementation PowerBar

@synthesize bar = _bar;
@synthesize base = _base;

+(PowerBar *) spriteWithFileName:(NSString *)baseFile barFile:(NSString *)barFile {
    
    PowerBar *obj = [[[PowerBar alloc] init] autorelease];
    obj.base = [CCSprite spriteWithFile:baseFile];
    obj.bar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:barFile]];
    obj.bar.type = kCCProgressTimerTypeBar;
    obj.bar.barChangeRate = ccp(1, 0);
    obj.bar.midpoint = ccp(0.0f, 0.0f);
    obj.bar.percentage = 100;
    [obj addChild:obj.base];
    [obj.bar setPosition:ccp(obj.base.contentSize.width*0.5f, obj.base.contentSize.height*0.5f)];
    [obj.base addChild:obj.bar z:-1];
    return obj;
}

-(id) init {
    
    if (self = [super init]) {

        
    }
    
    return self;
}

@end
