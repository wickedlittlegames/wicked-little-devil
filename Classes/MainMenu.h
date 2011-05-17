//
//  MainMenu.h
//  LittleDevil
//
//  Created by Andy Girvan on 09/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface MainMenu : CCLayer {
	bool menuchallengeMode; 

}
@property (nonatomic) bool menuchallengeMode;

+(id) scene;
-(void)initAudio;
-(void)initScore;
-(void)initMenus;

@end