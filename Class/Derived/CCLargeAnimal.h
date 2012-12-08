//
//  CCLargeAnimal.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMotionLessObject.h"

@interface CCLargeAnimal : CCMotionLessObject <PANIMATION> {
 
    @public
    NSString *name;
    int blood;
}

+(CCLargeAnimal *) spriteWithFileName:(NSString *)filename;
-(void) attack:(ccTime)dt;
-(void) defend:(ccTime)dt;

@end
