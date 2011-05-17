//
//  Platform.m
//  LittleDevil
//
//  Created by Andy Girvan on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Platform.h"


@implementation Platform
@synthesize fallingMarker, velocity, dead;


-(BOOL)touched
{
	self.fallingMarker = 1; 
	self.visible = YES; 
    CCTexture2D *imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"hell-platform-broken.png"]];
    [self setTexture: imageSwap];
    [imageSwap autorelease];

	self.dead = YES; 

	return YES;
}

@end
