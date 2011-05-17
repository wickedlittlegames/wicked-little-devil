//
//  Powerup.h
//  LittleDevil
//
//  Created by Andy Girvan on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Entity.h"
#import "cocos2d.h"

@interface Powerup : Entity {
	bool challengemode;
	NSString *effect;
}
@property(nonatomic) bool challengemode; 
@property(nonatomic,retain) NSString *effect; 

-(bool)generate:(int)type challengemode:(bool)challenge;
-(void)reset;


-(int)typepicker;

@end
