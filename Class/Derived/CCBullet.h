//
//  CCBullet.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"

enum BULLETSTATUS {
    PICKUP = 0,
    ATTACK = 1
    };

@interface CCBullet : CCStaticObject {
    
    @public
    BULLETSTATUS status;
    
    float yStep;
    @protected
    float xSpeed;
    float ySpeed;
    float width;
    float height;
    
    
}

+(CCBullet *) spriteWithFileName:(NSString *)filename;

-(void) setXSpeed:(float)x Y:(float)y;
-(void) getXSpeed:(float *)x Y:(float *)y;
-(void) start;
-(void) end;
-(void) update:(ccTime)dt;
-(void) collideCheck;

@end
