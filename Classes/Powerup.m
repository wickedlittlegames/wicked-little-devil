//
//  Powerup.m
//  LittleDevil
//
//  Created by Andy Girvan on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"
#define powerupCount 2

@implementation Powerup
@synthesize effect, challengemode;

-(bool)generate:(int)type challengemode:(bool)challenge
{
    if(!challenge) 
    {
        switch (type)
        {
            case 0:
                // Speed up
                [self initWithFile:@"powerup-boost.png"];
                self.effect = @"boost";
                break;
            case 1:
                // Speed up
                [self initWithFile:@"powerup-bounce.png"];
                self.effect = @"bounce";
                break;
            default:
                // Speed up
                [self initWithFile:@"powerup-boost.png"];
                self.effect = @"boost";
                break;
        }
    }
    else
    {
        switch (type)
        {
            case 0:
                // Ice reduce
                [self initWithFile:@"powerup-freeze.png"];
                self.effect = @"freeze";
                break;
            case 1:
                // Ice reduce
                [self initWithFile:@"powerup-freeze.png"];
                self.effect = @"freeze";
                break;                
        }
    }
    int x = (random() % 270) + 40;    
    int y = 480 + (random() % 1500);
    self.position = ccp(x,y);
    self.visible = YES; 
     
    return self.visible;
}
-(int)typepicker
{
    int pueffect = (arc4random() % powerupCount);
    return pueffect;
}

-(void)reset
{
    self.position = ccp(self.position.x, -40);
	self.visible = NO; 
}
- (void)dealloc {
	self.effect = nil;
	[super dealloc];    
}

@end
