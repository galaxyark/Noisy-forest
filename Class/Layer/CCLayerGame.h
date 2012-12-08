//
//  CCLayerGame.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayerContent.h"
#import "CCLayerControlPanel.h"

@interface CCLayerGame : CCLayer {
    
    CCLayerControlPanel *control;
    CCLayerContent *content;
}

@property (nonatomic, retain) CCLayerContent *content;
@property (nonatomic, retain) CCLayerControlPanel *control;

+(CCScene *) scene;
-(void) end;

@end
