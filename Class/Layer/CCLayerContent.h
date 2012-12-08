//
//  CCLayerContent.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface CCLayerContent : CCLayer {
    
    @private
    b2World *world;
}

+(CCScene *) scene;

@end
