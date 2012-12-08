//
//  CCMotionLessObject.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "CCObject.h"

@interface CCMotionLessObject : CCObject {
    
    
    @protected
    
    @public
    b2Body *body;
}

@property (atomic, readonly) BOOL isPhyEnable;


-(void)setPhyEnable:(BOOL)enable;

@end
