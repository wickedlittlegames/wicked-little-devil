//
//  MainMenu.h
//  LittleDevil
//
//  Created by Andy Girvan on 09/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MainMenu_challenge : CCLayer {
	bool menuchallengeMode; 

}

@property (nonatomic) bool menuchallengeMode;

+(id) scene;


@end
