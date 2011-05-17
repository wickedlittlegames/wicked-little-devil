//
//  Player.m
//  LittleDevil
//
//  Created by Andy Girvan on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize lives, dead,imageSwapped,dropin,dropping,positionAtTop;

-(void) animate
{
	if (self.position.x > 160)	
		[self runAction:[CCFlipX actionWithFlipX:YES]];
	else
		[self runAction:[CCFlipX actionWithFlipX:NO]];
}

@end
