//
//  CCFireBall.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"

@interface CCFireBall : CCStaticObject {


    @public
    float distance;
    float speed;
    float oriY;
    float m_distance;
    float power;
}
+(CCFireBall *) spriteWithFileName:(NSString *)filename;
+(CCFireBall *) loadWithPlist:(NSString *)plist name:(NSString *)name position:(CGPoint)position;

-(void) update:(ccTime)dt;
-(void) destory;

@end
