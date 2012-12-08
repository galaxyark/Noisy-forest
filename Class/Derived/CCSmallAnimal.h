//
//  CCSmallAnimal.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"

@interface CCSmallAnimal : CCStaticObject <PANIMATION> {
    
    @public
    NSString *name;
    
    @private
    BOOL direction;
}

+(CCSmallAnimal *) spriteWithFileName:(NSString *)filename;
-(void) runAwayRight;
-(void) update:(ccTime)dt;
-(void) runAwayLeft;
-(void) attack:(ccTime)dt;

@end
