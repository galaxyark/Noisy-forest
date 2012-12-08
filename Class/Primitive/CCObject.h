//
//  CCObject.h
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCObject : CCNode {
    
    
    @public
    int z;
    int tag;
    
    @protected
    CCSprite *_sprite;
    
    @private
    BOOL _isVisible;
}

@property (atomic, assign) CCSprite *sprite;
@property (atomic, readonly) BOOL isVisible;


-(void)setVisible:(BOOL)visible;
-(void)setPosition:(CGPoint)position;
-(BOOL) isVisualCollideWith: (id)collider radius:(float)radius;

@end


// define a protocol that some class should conform to implement animation
@protocol PANIMATION

@property (nonatomic, retain) NSMutableDictionary *d_anims;

-(void) runAnimation:(NSString *)name;
-(void) loadAnimation:(NSString *)name file:(NSString *)filename;

@optional
-(id) getAnimationByName:(NSString *)name;
@end