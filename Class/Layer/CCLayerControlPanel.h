//
//  CCLayerControlPanel.h
//  Garden Voice
//
//  Created by Shengzhe Chen on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SkillPanelBase.h"

@interface CCLayerControlPanel : CCLayer {
    
    @public
    SneakyJoystick *joystick;
    SkillPanelBase *skillpanel;
    
    @private
    bool beReady;
}

@property (nonatomic, readonly) SneakyJoystick *joystick;
@property (nonatomic, assign) CCLabelTTF *micVolume;
@property (nonatomic, assign) CCLabelTTF *fmodFreq;
@property (nonatomic, assign) CCLabelTTF *currTool;

+(CCScene *) scene;
+(CCLayerControlPanel *) sharedController;
-(void) refresh;
@end
