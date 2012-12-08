//
//  powerbar.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PowerBar : CCNode {
 
    CCProgressTimer *_bar;
    CCSprite *_base;
}

@property (nonatomic, assign) CCProgressTimer *bar;
@property (nonatomic, assign) CCSprite *base;

+(PowerBar *) spriteWithFileName:(NSString *)baseFile barFile:(NSString *)barFile;

@end
