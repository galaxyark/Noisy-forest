//
//  CCAbilityBall.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"

@interface CCAbilityBall : CCStaticObject {
    
    @public
    NSString *name;
    BOOL isInvoked;
    
}

+(CCAbilityBall *) spriteWithFileName:(NSString *)filename;

@end
