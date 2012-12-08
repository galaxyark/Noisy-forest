//
//  CCNotation.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCStaticObject.h"
#import "powerbar.h"

@interface CCNotation : CCStaticObject {
    
    @private
    
    int toneStatus;
    BOOL rightTone;
    BOOL rightInput;
    BOOL isPlaying;
    @public
    PowerBar *toneBar;
}

+(CCNotation *) spriteWithFileName:(NSString *)filename;
-(void) start;
-(void) end;
-(void) setupToneBar;

@end
