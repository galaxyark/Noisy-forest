//
//  CCElevator.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMotionLessObject.h"
#import "CCSharedData.h"

enum ElevatorStatus {
    WAITTING = 0,
    UP = 1,
    //for future use
    DOWN = 2,
    TOP = 3
};


@interface CCElevator : CCMotionLessObject {
    
    @private
    ElevatorStatus status;
}

+(CCElevator *) spriteWithFileName:(NSString *)filename;

@end
