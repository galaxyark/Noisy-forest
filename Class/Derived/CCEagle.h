//
//  CCEagle.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"

enum EAGLESTATUS {
    EAGLEWANDER = 0,
    EAGLEDIE = 1
};

@interface CCEagle : CCStaticObject<PANIMATION> {
    
    @public
    EAGLESTATUS status;
    
    @public
    float maxWidth;
    float minWidth;
    int blood;

    @private
    int direction;
    float speed;
    int bullets;
    float radius;
    float speScalor;
    float baseSpeed;
    
}

+(CCEagle *) spriteWithFileName:(NSString *)filename;

-(void) start;
-(void) end;
-(void) getDamage;
-(void) update:(ccTime)dt;
-(void) wander:(ccTime)dt;
-(void) throwBullet;
-(void) getDamage;
-(void) die;
-(void) evaluate:(ccTime)dt;
-(void) putAttackBullet:(ccTime)dt;

@end
