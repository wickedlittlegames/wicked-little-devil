//
//  Player.h
//  LittleDevil
//
//  Created by Andy Girvan on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Entity.h"

@interface Player : Entity {
	int lives;
	bool dead, imageSwapped,dropin,dropping,positionAtTop;
}

@property (nonatomic) int lives;
@property (nonatomic) bool dead,imageSwapped,dropin,dropping,positionAtTop;

-(void) animate;

@end
