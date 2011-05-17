//
//  Powerup_Effects.m
//  LittleDevil
//
//  Created by Andy Girvan on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupEffect.h"


@implementation PowerupEffect
@synthesize active,fxaded,imageSwapped, blinking;

-(bool)start:(NSString *)type
{
    self.effect = type;
    self.active = YES; 
    self.imageSwapped = NO; 
    self.blinking = NO; 
    return self.active;
}
-(void) blink:(int)blinks
{
    if(self.blinking == NO) {
        self.blinking = YES; 
        CCBlink *blink = [CCBlink actionWithDuration:1.0 blinks:blinks];
        id actionFinish = [CCCallFunc actionWithTarget:self selector:@selector(blinkFinished:)];
        [self runAction:[CCSequence actions:blink, actionFinish, nil]];
    }
}

-(void)blinkFinished: (id) sender {
    self.blinking = NO; 
}

@end
