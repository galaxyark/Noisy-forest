//
//  CCStoneObstacle.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMotionLessObject.h"

@interface CCStoneObstacle : CCMotionLessObject <PANIMATION> {
    
}

+(CCStoneObstacle *) spriteWithFileName:(NSString *)filename;
-(void) breaking;
@end
