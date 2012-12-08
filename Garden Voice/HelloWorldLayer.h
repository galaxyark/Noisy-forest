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
#import "GB2ShapeCache.h"
#import "GLES-Render.h"

@interface HelloWorldLayer : CCLayer {
    CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
}

+(CCScene *) scene;

@end
