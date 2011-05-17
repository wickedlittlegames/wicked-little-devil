//
//  Powerup_Effects.h
//  LittleDevil
//
//  Created by Andy Girvan on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Powerup.h"

@interface PowerupEffect : Powerup {
    bool active, fxaded, imageSwapped, blinking;
}
@property(nonatomic) bool active, fxaded, imageSwapped,blinking; 

-(bool)start:(NSString *)type;
-(void)blink:(int)blinks;
-(void)blinkFinished: (id) sender;

@end
