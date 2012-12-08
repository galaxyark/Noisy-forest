//
//  CCObject.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCObject.h"


@implementation CCObject
@synthesize sprite = _sprite;
@synthesize isVisible = _isVisible;

-(id) init {
 
    if (self = [super init]) {
        
        _isVisible = NO;
        _sprite = nil;
    }
    
    return self;
}

// show/hide the sprite
-(void)setVisible:(BOOL)visible {
    
    
    _isVisible = visible;
    
    if (self.sprite) {
        [self.sprite setVisible:visible];
    }
}


// translate the sprite's position
-(void)setPosition:(CGPoint)position {
    if (!self.sprite) {
        throw [NSException exceptionWithName:@"CCStaticObject Sprite NULL" reason:NULL userInfo:NULL];
        return;
    }
    
    [self.sprite setPosition:position];
}

// check with whether self is collided with collider
-(BOOL)isVisualCollideWith: (id)collider radius:(float)radius
{
    //throw [NSException exceptionWithName:@"Subclass isVisualCollideWith:" reason:NULL userInfo:NULL];
    
    if ([collider isKindOfClass:[CCObject class]]) {
        
        CGPoint m_pos = self.sprite.position;
        CGPoint c_pos = ((CCObject *)collider).sprite.position;
        
        float dis = ccpDistance(m_pos, c_pos);
        
        if (fabsf(dis)<=radius) {
            return YES;
        }
    }
    
    return NO;
}

-(void)dealloc {
    
    [_sprite release];
    [super dealloc];
}

@end
