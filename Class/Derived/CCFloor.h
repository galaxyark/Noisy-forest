//
//  CCFloor.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMotionLessObject.h"

@interface CCFloor : CCMotionLessObject {
    
    @public
    NSString *name;
}

+(CCFloor *) spriteWithFileName:(NSString *)filename;


@end
