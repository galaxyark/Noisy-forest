//
//  CCLayerMenu.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCLayerMenu : CCLayer {
    
    
    CCMenuItemFont *m_start;
    CCMenuItemFont *m_exit;
}

+(CCScene *) scene;

@end
