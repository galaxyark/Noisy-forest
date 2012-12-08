//
//  SkillPanelBase.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SkillPanelBase : CCSprite<CCTargetedTouchDelegate> {
 
    @private
    CCArray *tools;
    
    @public
    CGPoint oriPos;
    int flag;
}

@end
