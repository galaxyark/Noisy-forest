//
//  CCRio.m
//  test
//
//  Created by Shengzhe Chen on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCRio.h"
#import "CCLayerControlPanel.h"
#import "CCSharedData.h"
#import "MicrophoneController.h"
#import "CCFileUtils.h"
#import "CCBullet.h"
#import "CCLayerGame.h"

#define MAX_FREQ 300.0
#define MIN_FREQ 150.0
#define POWER_INCREATERATE 30

@implementation CCRio
@synthesize d_anims;

+(CCRio *) spriteWithFileName:(NSString *)filename {
    
    CCRio *obj = [[[CCRio alloc] init] autorelease];
    obj.sprite = [[CCSprite alloc] initWithFile:filename];
    
    [obj setupBars];
    
    [obj setVisible:NO];
    obj->body = NULL;
    
    return obj;
}

-(void) setupBars {
    
    copterBar = [PowerBar spriteWithFileName:@"vg_96_16_power_bar_copter.png" barFile:@"vg_96_16_power_bar.png"];
    [copterBar setPosition:ccp(self.sprite.contentSize.width*0.5f, self.sprite.contentSize.height + copterBar.bar.contentSize.height)];
    [self.sprite addChild:copterBar];
    [copterBar setVisible:NO];
    
    loudspeakerBar = [PowerBar spriteWithFileName:@"vg_96_16_power_bar_loudspeaker.png" barFile:@"vg_96_16_power_bar.png"];
    [loudspeakerBar setPosition:ccp(self.sprite.contentSize.width*0.5f, self.sprite.contentSize.height+loudspeakerBar.bar.contentSize.height)];
    [self.sprite addChild:loudspeakerBar];
    [loudspeakerBar setVisible:NO];

    shieldBar = [PowerBar spriteWithFileName:@"vg_96_16_power_bar_shield.png" barFile:@"vg_96_16_power_bar.png"];
    [shieldBar setPosition:ccp(self.sprite.contentSize.width*0.5f, self.sprite.contentSize.height+shieldBar.bar.contentSize.height)];
    [self.sprite addChild:shieldBar];
    [shieldBar setVisible:NO];
    
    crossbowBar = [PowerBar spriteWithFileName:@"vg_96_16_power_bar_crossbow.png" barFile:@"vg_96_16_power_bar.png"];
    [crossbowBar setPosition:ccp(self.sprite.contentSize.width*0.5f, self.sprite.contentSize.height+crossbowBar.bar.contentSize.height)];
    [self.sprite addChild:crossbowBar];
    [crossbowBar setVisible:NO];
}

-(id) init {
    
    if (self = [super init]) {
        
        self.d_anims = [[[NSMutableDictionary alloc] init] autorelease];
        
        activeTool = nil;
        tools = [[CCArray alloc] init];
        
        isTouchEnable = NO;
        
        bullets = 0;
        
        m_face = 1;
        
        [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget:self priority:0 paused:NO];
    }
    
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    
    if (location.y<[CCDirector sharedDirector].winSize.height*0.4f) {
        shotpos = ccp(0, 0);
    }
    else {
        shotpos = location;
    }
    
    return NO;
}

-(void) updatePosition:(ccTime)dt {
    
    b2Vec2 posMeter = self->body->GetPosition();
    
    CGPoint posSprite = ccp(posMeter.x * PTM_RATIO, posMeter.y * PTM_RATIO);
    CGSize contentSize = [[self sprite] contentSize];
    posSprite.x += contentSize.width*0.5f;
    posSprite.y += contentSize.height*0.5f;
    
    [[self sprite] setPosition:posSprite];
}

-(void) updateTools:(ccTime)dt {
    
    
    CCAbilityBall *tool;
    
    CCARRAY_FOREACH([[CCSharedData sharedData] arr_abilityBall], tool) {
        
        if ([self isVisualCollideWith:tool radius:tool.sprite.contentSize.width*0.5f]) {

            [tool setVisible:NO];
            [[tool sprite] removeFromParentAndCleanup:YES];
            [tools addObject:tool];
            [[[CCSharedData sharedData] arr_abilityBall] removeObject:tool];
        }
    }    
}

-(void) updateMove:(ccTime)dt {
    
    static NSString *currentAnim = nil;
    
    float velocity = [CCLayerControlPanel sharedController].joystick.velocity.x;

    b2Vec2 cvel = self->body->GetLinearVelocity();
    
    if (fabs(cvel.x) <= 2.0f) {
    
        float scalor = 2.0f;
        
        self->body->SetLinearVelocity(b2Vec2(velocity*scalor, cvel.y));
        
    }
    if (velocity > 0) {
    
        m_face = 1;
        
        if (activeTool != nil) {
                
            if ([activeTool->name isEqualToString:@"copter"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"copter_fly_right"]) {
                        
                        [self runAnimation:@"copter_fly_right"];
                        [currentAnim release];
                        currentAnim = @"copter_fly_right";
                    }
                }
                else {
                    if (![currentAnim isEqualToString:@"copter_walk_right"]) {
                        
                        [self runAnimation:@"copter_walk_right"];
                        [currentAnim release];
                        currentAnim = @"copter_walk_right";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"loudspeaker"]) {
                    
                if (activeTool->isInvoked) {
                        
                    if (![currentAnim isEqualToString:@"loud_blow_right"]) {
                            
                        [self runAnimation:@"loud_blow_right"];
                        [currentAnim release];
                        currentAnim = @"loud_blow_right";
                    }
                }
                else {
                        
                    if (![currentAnim isEqualToString:@"loud_walk_right"]) {
                            
                        [self runAnimation:@"loud_walk_right"];
                        [currentAnim release];
                        currentAnim = @"loud_walk_right";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"shield"]) {
                    
                if (activeTool->isInvoked) {
                
                    if (![currentAnim isEqualToString:@"shield_defend_right"]) {
                        
                        [self runAnimation:@"shield_defend_right"];
                        [currentAnim release];
                        currentAnim = @"shield_defend_right";
                    }
                }
                else {
                    
                    if (![currentAnim isEqualToString:@"shield_walk_right"]) {
                        
                        [self runAnimation:@"shield_walk_right"];
                        [currentAnim release];
                        currentAnim = @"shield_walk_right";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"crossbow"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"cross_shot_right"]) {
                        
                        [self runAnimation:@"cross_shot_right"];
                        [currentAnim release];
                        currentAnim = @"cross_shot_right";
                    }
                }
                else {
                    if (![currentAnim isEqualToString:@"cross_walk_right"]) {
                        
                        [self runAnimation:@"cross_walk_right"];
                        [currentAnim release];
                        currentAnim = @"cross_walk_right";
                    }
                }
                
            }
            else {
                if (![currentAnim isEqualToString: @"walk_right"]) {
                    [self runAnimation:@"walk_right"];
                    [currentAnim release];
                    currentAnim = @"walk_right";
                }
            }
        }
        else {

            if (![currentAnim isEqualToString: @"walk_right"]) {
            
                [self runAnimation:@"walk_right"];
                [currentAnim release];
                currentAnim = @"walk_right";
            }
        }
    }
    else if(velocity < 0) {
        
        m_face = 0;
        
        if (activeTool != nil) {
            
            if ([activeTool->name isEqualToString:@"copter"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"copter_fly_left"]) {
                        
                        [self runAnimation:@"copter_fly_left"];
                        [currentAnim release];
                        currentAnim = @"copter_fly_left";
                    }
                }
                else {
                    if (![currentAnim isEqualToString:@"copter_walk_left"]) {
                        
                        [self runAnimation:@"copter_walk_left"];
                        [currentAnim release];
                        currentAnim = @"copter_walk_left";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"loudspeaker"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"loud_blow_left"]) {
                        
                        [self runAnimation:@"loud_blow_left"];
                        [currentAnim release];
                        currentAnim = @"loud_blow_left";
                    }
                }
                else {
                    
                    if (![currentAnim isEqualToString:@"loud_walk_left"]) {
                        
                        [self runAnimation:@"loud_walk_left"];
                        [currentAnim release];
                        currentAnim = @"loud_walk_left";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"shield"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"shield_defend_left"]) {
                        
                        [self runAnimation:@"shield_defend_left"];
                        [currentAnim release];
                        currentAnim = @"shield_defend_left";
                    }
                }
                else {
                    
                    if (![currentAnim isEqualToString:@"shield_walk_left"]) {
                        
                        [self runAnimation:@"shield_walk_left"];
                        [currentAnim release];
                        currentAnim = @"shield_walk_left";
                    }
                }
            }
            else if ([activeTool->name isEqualToString:@"crossbow"]) {
                
                if (activeTool->isInvoked) {
                    
                    if (![currentAnim isEqualToString:@"cross_shot_left"]) {
                        
                        [self runAnimation:@"cross_shot_left"];
                        [currentAnim release];
                        currentAnim = @"cross_shot_left";
                    }
                }
                else {
                    if (![currentAnim isEqualToString:@"cross_walk_left"]) {
                        
                        [self runAnimation:@"cross_walk_left"];
                        [currentAnim release];
                        currentAnim = @"cross_walk_left";
                    }
                }
            }
            else {
                
                if (![currentAnim isEqualToString: @"walk_left"]) {
                    
                    [self runAnimation:@"walk_left"];
                    [currentAnim release];
                    currentAnim = @"walk_left";
                }
            }
        }
        else {
            
            if (![currentAnim isEqualToString: @"walk_left"]) {
                
                [self runAnimation:@"walk_left"];
                [currentAnim release];
                currentAnim = @"walk_left";
            }
        }
    }
    else {
        
        if (activeTool == nil) {
            return;
        }
        if ([activeTool->name isEqualToString:@"copter"]) {
            
            if (activeTool->isInvoked) {
                
                switch (m_face) {
                    case 1:
                        if (![currentAnim isEqualToString:@"copter_fly_right"]) {
                            
                            [self runAnimation:@"copter_fly_right"];
                            [currentAnim release];
                            currentAnim = @"copter_fly_right";
                        }
                        break;
                    case 0:
                        if (![currentAnim isEqualToString:@"copter_fly_left"]) {
                            
                            [self runAnimation:@"copter_fly_left"];
                            [currentAnim release];
                            currentAnim = @"copter_fly_left";
                        }
                        break;
                    default:
                        break;
                }

            }
            else {
                switch (m_face) {
                case 1:
                    if (![currentAnim isEqualToString:@"copter_walk_right"]) {
                    
                        [self runAnimation:@"copter_walk_right"];
                        [currentAnim release];
                        currentAnim = @"copter_walk_right";
                    }
                break;
                case 0:
                    if (![currentAnim isEqualToString:@"copter_walk_left"]) {
                        
                        [self runAnimation:@"copter_walk_left"];
                        [currentAnim release];
                        currentAnim = @"copter_walk_left";
                    }                    break;
                default:
                    break;
            }
            }
        }
        else if ([activeTool->name isEqualToString:@"loudspeaker"]) {
            if (activeTool->isInvoked) {
                
                switch (m_face) {
                    case 1:
                        if (![currentAnim isEqualToString:@"loud_blow_right"]) {
                            
                            [self runAnimation:@"loud_blow_right"];
                            [currentAnim release];
                            currentAnim = @"loud_blow_right";
                        }
                        
                        break;
                    case 0:
                        if (![currentAnim isEqualToString:@"loud_blow_left"]) {
                            
                            [self runAnimation:@"loud_blow_left"];
                            [currentAnim release];
                            currentAnim = @"loud_blow_left";
                        }
                        
                        break;
                    default:
                        break;
                }

                
            }
            else {
                switch (m_face) {
                case 1:
                    if (![currentAnim isEqualToString:@"loud_walk_right"]) {
                        
                        [self runAnimation:@"loud_walk_right"];
                        [currentAnim release];
                        currentAnim = @"loud_walk_right";
                    }

                    break;
                case 0:
                    if (![currentAnim isEqualToString:@"loud_walk_left"]) {
                        
                        [self runAnimation:@"loud_walk_left"];
                        [currentAnim release];
                        currentAnim = @"loud_walk_left";
                    }

                    break;
                default:
                    break;
            }
            }
        }
        else if ([activeTool->name isEqualToString:@"shield"]) {
            if (activeTool->isInvoked) {
                switch (m_face) {
                    case 1:
                        if (![currentAnim isEqualToString:@"shield_defend_right"]) {
                            [self runAnimation:@"shield_defend_right"];
                            [currentAnim release];
                            currentAnim = @"shield_defend_right";
                        }
                        
                        break;
                    case 0:
                        if (![currentAnim isEqualToString:@"shield_defend_left"]) {
                            [self runAnimation:@"shield_defend_left"];
                            [currentAnim release];
                            currentAnim = @"shield_defend_left";
                        }
                        
                        
                        break;
                    default:
                        break;
                }

            }
            else {
                switch (m_face) {
                case 1:
                    if (![currentAnim isEqualToString:@"shield_walk_right"]) {
                        [self runAnimation:@"shield_walk_right"];
                        [currentAnim release];
                        currentAnim = @"shield_walk_right";
                    }

                    break;
                case 0:
                    if (![currentAnim isEqualToString:@"shield_walk_left"]) {
                        [self runAnimation:@"shield_walk_left"];
                        [currentAnim release];
                        currentAnim = @"shield_walk_left";
                    }

                    
                    break;
                default:
                    break;
            }
            }
        }
        else if ([activeTool->name isEqualToString:@"crossbow"]) {
            if (activeTool->isInvoked) {
                switch (m_face) {
                    case 1:
                        if (![currentAnim isEqualToString:@"cross_shot_right"]) {
                            [self runAnimation:@"cross_shot_right"];
                            [currentAnim release];
                            currentAnim = @"cross_shot_right";
                        }
                        
                        break;
                    case 0:
                        if (![currentAnim isEqualToString:@"cross_shot_left"]) {
                            [self runAnimation:@"cross_shot_left"];
                            [currentAnim release];
                            currentAnim = @"cross_shot_left";
                        }
                        break;
                        
                    default:
                        break;
                }

            }
            else {
                switch (m_face) {
                case 1:
                    if (![currentAnim isEqualToString:@"cross_walk_right"]) {
                        [self runAnimation:@"cross_walk_right"];
                        [currentAnim release];
                        currentAnim = @"cross_walk_right";
                    }

                    break;
                case 0:
                    if (![currentAnim isEqualToString:@"cross_walk_left"]) {
                        [self runAnimation:@"cross_walk_left"];
                        [currentAnim release];
                        currentAnim = @"cross_walk_left";
                    }
                    break;

                default:
                    break;
            }
            }
        }
        else {
            
            switch (m_face) {
                case 1:
                    if (![currentAnim isEqualToString: @"walk_right"]) {
                        [self runAnimation:@"walk_right"];
                        [currentAnim release];
                        currentAnim = @"walk_right";
                    }

                    break;
                case 0:
                    if (![currentAnim isEqualToString: @"walk_left"]) {
                        [self runAnimation:@"walk_left"];
                        [currentAnim release];
                        currentAnim = @"walk_left";
                    }

                    break;
                default:
                    break;
            }
        }
    }
    
}

-(void) update:(ccTime)dt {
    
    
    [self updatePosition:dt];
    [self updateTools:dt];

    if (activeTool != nil) {
        
        if ([activeTool->name isEqualToString:@"copter"]) {
            
            if (isTouchEnable) {
                
                [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
                isTouchEnable = NO;
            }
            
            [copterBar setVisible:YES];
            [loudspeakerBar setVisible:NO];
            [shieldBar setVisible:NO];
            [crossbowBar setVisible:NO];
            
            
            [self copter];
        }
        else if ([activeTool->name isEqualToString:@"loudspeaker"]) {
            
            if (isTouchEnable) {
                
                [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
                isTouchEnable = NO;
            }
            
            
            [copterBar setVisible:NO];
            [loudspeakerBar setVisible:YES];
            [shieldBar setVisible:NO];
            [crossbowBar setVisible:NO];
            
            [self loudSpeaker];
        }
        else if ([activeTool->name isEqualToString:@"shield"]) {
            
            if (isTouchEnable) {
                
                [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
                isTouchEnable = NO;
            }
            
            
            [copterBar setVisible:NO];
            [loudspeakerBar setVisible:NO];
            [shieldBar setVisible:YES];
            [crossbowBar setVisible:NO];
            
            [self shield:dt];
        }
        else if ([activeTool->name isEqualToString:@"crossbow"]) {
            
            if (!isTouchEnable) {
                [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
                isTouchEnable = YES;
            }
            
            
            [copterBar setVisible:NO];
            [loudspeakerBar setVisible:NO];
            [shieldBar setVisible:NO];
            [crossbowBar setVisible:YES];
            
            [self crossbow:dt];
        }
        else {
         
            if (isTouchEnable) {
                
                [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
                isTouchEnable = NO;
            }
            
            [copterBar setVisible:NO];
            [loudspeakerBar setVisible:NO];
            [shieldBar setVisible:NO];
            [crossbowBar setVisible:NO];
        }
    }
    else {
        
        if (isTouchEnable) {
            
            [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
            isTouchEnable = NO;
        }
        
        [copterBar setVisible:NO];
        [loudspeakerBar setVisible:NO];
        [shieldBar setVisible:NO];
        [crossbowBar setVisible:NO];
    }
    
    [self updateMove:dt];
}

-(void) copter {
    
    static BOOL isJumping = NO;
    static float lastY = 0.0;
    static int jumpingTime = 0;
    static float input = 0.0;
    b2Vec2 cPos = self->body->GetPosition();
    
    if (!isJumping) {
    
        input = [MicrophoneController sharedInstance].lowPassResults;
    }
    
    float volume = [MicrophoneController sharedInstance].lowPassResults;
    
    if (volume*100 > 100) {

        copterBar.bar.percentage = 100;
    }
    else {
    
        copterBar.bar.percentage = volume*100;
    }
    
    if (input > 0.55 && isJumping == NO) {
        
        jumpingTime = 1;
        isJumping = YES;
        activeTool->isInvoked = YES;
        lastY = cPos.y;
    }
    
    if (cPos.y == lastY && jumpingTime == 0) {

        isJumping = NO;
        activeTool->isInvoked = NO;
    }
    
    if (jumpingTime > 0) {
        
        float scalor = 5+(input-0.55)*5;
        
        float force = self->body->GetMass()*scalor;
        self->body->ApplyLinearImpulse(b2Vec2(0, force), self->body->GetWorldCenter());
        jumpingTime--;
    }
    
    lastY = cPos.y;

}

-(void) loudSpeaker {
    
    float input = [MicrophoneController sharedInstance].lowPassResults;
    
    float freq = input*100;
    if (freq > 100) {
        freq = 100;
    }
    
    loudspeakerBar.bar.percentage = freq;
    
    if (input>0.85) {
        
        self->activeTool->isInvoked = YES;
        
        CGPoint rioPos = [self.sprite position];
        
        CCStoneObstacle *stone;
        
        CCARRAY_FOREACH([CCSharedData sharedData].arr_stoneObstacle, stone) {
            
            float radius = 0.5f;
            float adis = fabsf([stone sprite].position.x - rioPos.x);
            float maxdis = stone.sprite.contentSize.width*0.5f+self.sprite.contentSize.width*(0.5f+radius);
            if (adis <= maxdis) {

                [[[CCSharedData sharedData] arr_dustbin] addObject:stone];
                [[[CCSharedData sharedData] arr_stoneObstacle] removeObject:stone];
                [stone runAnimation:@"breaking"];
                
                return;
            }
        }
        
        CCSmallAnimal *sanim;
        CCARRAY_FOREACH([[CCSharedData sharedData] arr_smallAnimal], sanim) {
            
            float radius = 0.5f;
            
            float adis = sqrtf(powf((sanim.sprite.position.x - rioPos.x), 2.0) + powf(sanim.sprite.position.y - rioPos.y, 2.0));
            
            float maxdis = sanim.sprite.contentSize.width*0.5f+self.sprite.contentSize.width*(0.5f+radius);
            if (adis <= maxdis) {
                
                [[[CCSharedData sharedData] arr_dustbin] addObject:sanim];
                [[[CCSharedData sharedData] arr_smallAnimal] removeObject:sanim];
                
                if ([sanim->name isEqualToString:@"mole"]) {
                    
                    id action1 = [sanim getAnimationByName:@"wakeup"];
                    id action2 = [sanim getAnimationByName:@"run_right"];
                    [sanim.sprite stopAllActions];
                    [sanim.sprite runAction:[CCSequence actions:action1, action2, nil]];
                }
                else if ([sanim->name isEqualToString:@"attack"]) {
                    
                    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(attack:) forTarget:sanim];
                    [[[CCDirector sharedDirector] scheduler] unscheduleUpdateForTarget:sanim];

                    id action1 = [sanim getAnimationByName:@"wakeup"];
                    id action2 = [sanim getAnimationByName:@"run_left"];
                    [sanim.sprite stopAllActions];
                    [sanim.sprite runAction:[CCSequence actions:action1, action2, nil]];
                }
                
                
                return;
            }
        }
    }
    else {
        
        activeTool->isInvoked = NO;
    }
}

-(void) shield:(ccTime)dt {
    
    float freq = [MicrophoneController sharedInstance].frequency;
    
    float perc = freq/10;
    
    if (perc>100) {

        perc = 100;
    }
    shieldBar.bar.percentage = perc;
    if (freq>=MIN_FREQ && freq<=MAX_FREQ) {
     
        activeTool->isInvoked = YES;
    }
    else {
        
        activeTool->isInvoked = NO;
    }
}

-(void) crossbow:(ccTime)dt {
    
    if (!crossbowBar)
        return;
    
    float volumn = [[MicrophoneController sharedInstance] lowPassResults];
    float power = crossbowBar.bar.percentage;
    
    if (volumn>0.6) {

        activeTool->isInvoked = YES;

        if ((power+=dt*POWER_INCREATERATE) >= 100) {
            
            power = 100;
        }
    }
    else {
        
        activeTool->isInvoked = NO;
        power = 0;
    }
    crossbowBar.bar.percentage = power;
    
    if (bullets > 0 && shotpos.x != 0 && shotpos.y != 0) {
        
        CGPoint camPos;
        float dummy;
        float xspe, yspe;
        [[self.sprite parent].camera centerX:&camPos.x centerY:&camPos.y centerZ:&dummy];
        CGPoint target = ccpAdd(shotpos, camPos);
        CGPoint start = self.sprite.position;
        CGPoint vector = ccpSub(target, start);
        float scalor = 7.5;
        if (vector.y == 0) {
            
            xspe = power*scalor;
            yspe = 0.0f;
        }
        else {
            
            float a = atan2f(vector.y, vector.x);
            xspe = power*cosf(a)*scalor;
            yspe = power*sinf(a)*scalor;
        }
        CCBullet *bullet = [CCBullet spriteWithFileName:@"vg_48_48_Bird_Egg.png"];
        [bullet setPosition:start];
        [bullet setXSpeed:xspe Y:yspe];
        bullet->status = ATTACK;
        [self.sprite.parent addChild:bullet.sprite];
        [bullet start];
        bullets--;
        shotpos = ccp(0, 0);
    }
}

-(void) loadAnimation:(NSString *)name file:(NSString *)filename {
    
    if ([d_anims objectForKey:name] == nil) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:filename];
        
        if ([filename hasSuffix:@".plist"]) {
            filename = [[CCFileUtils sharedFileUtils] removeSuffix:@".plist" fromPath:filename];
        }
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for (int i=1; i<5; i++) {
            NSString *frameName = [NSString stringWithFormat:@"%@_%d.png", filename, i];
            [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.2f];
        id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
        
        [d_anims setObject:action forKey:name];
    }
}

-(void) runAnimation:(NSString *)name {
    
    id action = [d_anims objectForKey:name];
    
    if (action != nil) {
        
        [[self sprite] stopAllActions];
        [[self sprite] runAction:action];
    }
    
}

-(void) dealloc {
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [self.d_anims release];
    activeTool = nil;
    [tools release];
    [super dealloc];
}

@end
