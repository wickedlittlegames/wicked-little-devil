//
//  Gameplay.h
//  LittleDevil
//
//  Created by Andy Girvan on 19/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface Gameplay_Challenge : CCLayer 
{
	CGPoint touchLocation;
	bool challengeMode, gameStarted, beactive,godpoweractive,godpowerEffectActive,dropinActive,resuming; 
	int difToInt, scoreInt, highScore, ptime, btime,btype,godpower,godpowerType,dtime;
}

@property (nonatomic) int difToInt, scoreInt, highScore, ptime, etime, btime, btype,godpower,godpowerType,dtime;
@property (nonatomic) bool challengeMode, gameStarted, top, beactive,godpoweractive, godpowerEffectActive,dropinActive,resuming;
@property (nonatomic) CGPoint touchLocation;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(void)initAudio;
-(void)initButtons;
-(void)initCharacters;
-(void)initEnemies;
-(void)initLabels; 
-(void)initPlatforms;
-(void)initScore;
-(void)initWorld;
-(void)initChallenge;
-(void)initPowerups; 

-(void)resetNumbers;

-(void)gameMovement;
-(void)gameMovementDevil;
-(void)gameMovementEnemy;
-(void)gameMovementPowerup;	
-(void)gameMovementPlatform;
-(void)gameMovementBG;	

-(void)gameIntersects;
-(void)gameIntersectsEnemy;
-(void)gameIntersectsPlatform;
-(void)gameIntersectsPowerup;
-(void)gameIntersectsOther;

-(void)gameGenerate;
-(void)gameGenerateEnemy;
-(void)gameGeneratePlatform;
-(void)gameGeneratePowerup;

-(void)gameEffects;
-(void)gameEffectsPowerup;
-(void)gameBadEffects:(int)betype;
-(void)gameGodEffects:(int)gptype;
-(void)gameScores;

-(void)endGame;

/* Leaderboard */
- (void) reportScore: (int64_t) score forCategory: (NSString*) category;


@end