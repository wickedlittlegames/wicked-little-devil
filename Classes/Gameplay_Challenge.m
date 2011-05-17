//
//  Gameplay.m
//  LittleDevil
//
//  Created by Andy Girvan on 19/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Gameplay_Challenge.h"
#import "AppSpecificValues.h"
#import "GameSpecificValues.h"

#import "Player.h"
#import "Platform.h"
#import "Enemy.h"
#import "Powerup.h"
#import "PowerupEffect.h"

#import	"MainMenu_challenge.h"

#import "SimpleAudioEngine.h"

// initialize objects
CGPoint jumpVelocity;
CGRect platformRect[platformCount], floorRect;

// Platforms
Platform *gameFloor, *platform[platformCount]; 

// Characters
Player *devil;
Enemy  *enemy;
Enemy *birdPoop, *bubble; 
Powerup *pu;
PowerupEffect *pue, *bouncycastle;
CCParticleExplosion *emitter, *enemyemitter, *bcfx;

// Sprites
CCSprite *bg[bgcount], *lifeCounter[3], *splatter;
CCTexture2D *imageSwap, *bubbleimageSwapRevert, *bubbleimageSwap;

// Counters & Labels
CCLabel *scoreCounter, *pauseText, *dropinText, *bonusCounter;
CCColorLayer *pauseLayer, *fireLayer, *dropinLayer;
CCMenu *mutemenu;

// Text
NSString *highScoreText, *currentScoreText, *bonusScoreText;
NSString *devilIMG_chal			= @"Devil.png";
NSString *platformIMG_chal		= @"hell-platform.png";
NSString *pauseIMG_chal			= @"pause.png";
NSString *muteIMG_chal			= @"mute-soundon.png";
NSString *floorIMG_chal			= @"floor.png";
NSString *platformSFX_chal		= @"popLow.mp3";
NSString *platformGFX_chal		= @"explosion.plist";
NSString *font_chal				= @"Futura";
NSString *lifeIMG_chal			= @"spring.png";
NSString *deadIMG_chal			= @"dead.png";
NSString *mainmenuIMG_chal		= @"mainmenu.png";
NSString *restartmenuIMG_chal	= @"restartmenu.png";
NSString *infoIMG_chal			= @"info.png";
NSString *dropinNumber_chal      = @"0";

BOOL added;
float difference;

@implementation Gameplay_Challenge
@synthesize touchLocation, challengeMode, gameStarted, 
difToInt, scoreInt, highScore, ptime, etime, btime, top, beactive, btype,
godpower,godpoweractive, godpowerType,godpowerEffectActive,dtime,dropinActive,resuming;

+(id) scene
{
	CCScene *scene = [CCScene node];
	Gameplay_Challenge *layer = [Gameplay_Challenge node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) { 
        NSLog(@"Loaded"); 
        challengeMode = YES; 
        NSLog(@"CM Enabled"); 
        if(challengeMode) [self initChallenge];
        NSLog(@"CM Init"); 
        [self initAudio];
        NSLog(@"audio Init"); 
        
        [self initScore];
        NSLog(@"initScore Init"); 
        
        [self initLabels]; 
        NSLog(@"initLabels Init"); 
        
        [self initButtons];
        NSLog(@"initButtons Init"); 
        
        [self initWorld];        NSLog(@"initWorld Init"); 
        
        [self initPlatforms];
        NSLog(@"initPlatforms Init"); 
        
        [self initCharacters];
        NSLog(@"initCharacters Init"); 
        
        [self initEnemies];
        NSLog(@"initEnemies Init"); 
        
        [self initPowerups];         NSLog(@"initPowerups Init"); 
        
        [self resetNumbers];        NSLog(@"resetNumbers Init"); 
        
        
        [self schedule:@selector(gameLoop:) interval:0];
        [self schedule:@selector(timerScore:) interval:1.0f];
        [self schedule:@selector(timerPower:) interval:1.0f];
        [self schedule:@selector(timerEffect:) interval:1.0f];
        [self schedule:@selector(timerBadEffect:) interval:1.0f];    
        [self schedule:@selector(timerDropin:) interval:1.0f];   

        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
    }
	return self;
}

-(void) gameLoop: (ccTime)aDelta  
{	
	jumpVelocity.y -= gravity;
	difference = 300 - devil.position.y;
	
	if(resuming == NO) { if (difference < 0) difToInt -= (int)difference; }
	[self gameEffects];
    
	[self gameMovement];
	[self gameIntersects];
	[self gameGenerate];
	
	[self gameScores];
}

/********************************************************************************************************************************/
// GAMEPLAY METHODS
/********************************************************************************************************************************/
- (void) gameMovement
{
	[self gameMovementDevil];
    if(!challengeMode) [self gameMovementEnemy];
	[self gameMovementPowerup];	
	[self gameMovementPlatform];
	[self gameMovementBG];	
}

- (void) gameMovementDevil
{
	if(resuming == NO) {
        if (difference < 0) 
            devil.position = ccp(devil.position.x + jumpVelocity.x, devil.position.y + jumpVelocity.y + difference);
        else {
            devil.position = ccp(devil.position.x + jumpVelocity.x, devil.position.y + jumpVelocity.y); } 
    }
    
    if(devil.dropping && resuming == YES) {
        if(devil.positionAtTop == YES) {
            devil.position = ccp(devil.position.x, screenHeight + 100);
            devil.positionAtTop = NO;
        }
        difference = 0;
        devil.position = ccp(devil.position.x, devil.position.y - 10);
        if(devil.position.y < 20) { devil.dropping = NO; devil.dropin = NO; resuming = NO; devil.positionAtTop = YES; dtime = 0; } 
    }
	
	[devil animate]; 
	
	if (devil.position.y < -25 && resuming == NO)
    {
        if(devil.lives < 1) {
            [self endGame];
        }
        else {
            if(devil.dropin == NO && resuming == NO) 
            {
                resuming = YES; 
                devil.lives--;
                lifeCounter[devil.lives].visible = NO;
                dropinActive = NO;
                devil.dropin = YES;
                dtime = 0;
            }
        }
    }
    
    if(devil.dropin) {
        if(dtime < 5) {
            devil.visible = NO;
            switch (dtime) {
                case 0:
                    dropinNumber_chal = [NSString stringWithFormat:@"Get Ready!",dtime];
                    break;
                case 1:
                    dropinNumber_chal = [NSString stringWithFormat:@"Get Ready!%",dtime]; 
                    break;
                case 2:
                    dropinNumber_chal = [NSString stringWithFormat:@"%3",dtime]; 
                    break;
                case 3:
                    dropinNumber_chal = [NSString stringWithFormat:@"%2",dtime]; 
                    break;
                case 4:
                    dropinNumber_chal = [NSString stringWithFormat:@"%1",dtime]; 
                    break;
                default:
                    dropinNumber_chal = [NSString stringWithFormat:@"",dtime]; 
                    break;
            }
            
            if(dropinActive == NO) {
                dropinLayer.visible = YES; 
                dropinText.visible = YES;
                dropinActive = YES; 
            }
            else {
                [dropinText setString:dropinNumber_chal];
            }
        }
        else {
            devil.dropin = NO; 
            devil.dropping = YES; 
            devil.positionAtTop = YES;
            devil.visible = YES;
            dropinLayer.visible = NO; 
            dropinText.visible = NO;
        }
    }
    
	if (devil.position.x != touchLocation.x && !devil.dead) 
	{
		float diff = touchLocation.x - devil.position.x;
		if(beactive && btype == 0) {
            if (diff > touchDiffLag)  diff = touchDiffLag;
            if (diff < -touchDiffLag) diff = -touchDiffLag;
        }
        else {
            if (diff > touchDiff)  diff = touchDiff;
            if (diff < -touchDiff) diff = -touchDiff;
        }
		
		CGPoint newxLocation = CGPointMake(devil.position.x + diff, devil.position.y);
		devil.position = newxLocation;
	}
}

- (void) gameMovementEnemy
{
	if (difference < 0 && enemy.enemyType != 4)
	{
		enemy.position = ccp(enemy.position.x, enemy.position.y + difference); 
		enemy.ybase = enemy.ybase + difference; 	
	}
    if (enemy.enemyType == 1) { 
        if(enemy.bubbleActive == NO) {
            int randomPoop = random() % 3800; 
            if(randomPoop > 3787) {
                bubble = [Enemy spriteWithFile:@"bubble.png" rect:CGRectMake(0,0,67,67)]; 
                [bubble setPosition:ccp(random() % screenWidth, 20)]; 
                [self addChild:bubble z:3];
                bubble.xbase = bubble.position.x; 
                bubble.ybase = bubble.position.y; 
                enemy.bubbleActive = YES; 
            }
        }
        if(enemy.bubbleActive == YES) {
            bubble.position = ccp(bubble.xbase + sin((bubble.position.y+0.5)/30) * 40, bubble.position.y + 1.5);
            if(bubble.position.y > screenHeight + 30) { 
                enemy.bubbleActive = NO; 
                [self removeChild:bubble cleanup:YES];
            }
            if(devil.position.y > startPlanet) { 
                bubble.visible = NO;
                enemy.bubbleActive = NO; 
                [self removeChild:bubble cleanup:YES];
            }
        }
    }
    if (enemy.enemyType == 2) { 
        enemy.position = ccp(enemy.position.x, screenHeight - 25); 
        
        if(enemy.birdPoopActive == NO) {
            int randomPoop = random() % 3000; 
            if(randomPoop > 2965) {
                birdPoop = [Enemy spriteWithFile:@"poop.png" rect:CGRectMake(0,0,20,20)]; 
                [birdPoop setPosition:ccp(enemy.position.x, enemy.position.y)]; 
                [self addChild:birdPoop z:3];
                enemy.birdPoopActive = YES; 
            }
        }
        if(enemy.birdPoopActive == YES) {
            birdPoop.position = ccp(birdPoop.position.x, birdPoop.position.y - 4); 
            if(birdPoop.position.y < -20) { 
                enemy.birdPoopActive = NO; 
                [self removeChild:birdPoop cleanup:YES];
            }
            if(devil.position.y > startSpace) { 
                enemy.birdPoopActive = NO; 
                birdPoop.visible = NO; 
                [self removeChild:birdPoop cleanup:YES];
            }
        }
    }
    
    if(enemy.enemyType == 3) {
        int randomPoop = random() % 200; 
        if(randomPoop > 150) {
            
            if(enemy.meteorActive == NO) { 
                int picker = random() % 6;
                if(picker == 0) picker = random() % 6; 
                if(picker == 0) picker = random() % 6; 
                if(picker == 0) picker = 1; 
                
                switch (picker)
                {
                    case 1:
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor.plist"];
                        enemyemitter.position = ccp(screenWidth + 200, screenHeight + 200); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 1;
                        break; 
                        
                    case 2: 
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor2.plist"];
                        enemyemitter.position = ccp(-200, screenHeight + 200); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 2; 
                        break;
                        
                    case 3: 
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor3.plist"];
                        enemyemitter.position = ccp(screenWidth - random() % 300, screenHeight + 200); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 3; 
                        break;
                        
                    case 4: 
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor4.plist"];
                        enemyemitter.position = ccp(-200, screenHeight - random() % 150); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 4; 
                        break;
                        
                    case 5: 
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor5.plist"];
                        enemyemitter.position = ccp(screenWidth + 200, screenHeight - random() % 150); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 5; 
                        break; 
                        
                    default:
                        enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"meteor.plist"];
                        enemyemitter.position = ccp(screenWidth + 200, screenHeight + 200); 
                        [enemyemitter setAutoRemoveOnFinish:YES];
                        
                        [self addChild:enemyemitter z:3];
                        enemy.direction = 1; 
                        break;
                }
                
                enemy.meteorActive = YES; 
            }
        }
        if(enemy.meteorActive == YES) {
            if(enemy.direction == 1) { 
                enemyemitter.position = ccp(enemyemitter.position.x - 3, enemyemitter.position.y - 3);
                if(enemyemitter.position.y < -200) { 
                    enemy.meteorActive = NO; 
                }
            }
            if(enemy.direction == 2) { 
                enemyemitter.position = ccp(enemyemitter.position.x + 3, enemyemitter.position.y - 3);
                if(enemyemitter.position.y < -200) { 
                    enemy.meteorActive = NO; 
                }
            }
            if(enemy.direction == 3) { 
                enemyemitter.position = ccp(enemyemitter.position.x, enemyemitter.position.y - 15);
                if(enemyemitter.position.y < -1100) { 
                    enemy.meteorActive = NO; 
                }
            }
            if(enemy.direction == 4) { 
                enemyemitter.position = ccp(enemyemitter.position.x + 3, enemyemitter.position.y - 3);
                if(enemyemitter.position.y < -200) { 
                    enemy.meteorActive = NO; 
                }
            }
            if(enemy.direction == 5) { 
                enemyemitter.position = ccp(enemyemitter.position.x - 3, enemyemitter.position.y - 3);
                if(enemyemitter.position.y < -200) { 
                    enemy.meteorActive = NO; 
                }
            }
            
        }
    }
    if(enemy.enemyType == 4) {
        beactive = YES; 
        btype = 4; 
    }
    
	int type = 0;
    
    int height = difToInt/10;
    
    if(height > startWater) { enemy.visible = NO; type = 1; }
    
    if(height > startPlanet) { 
        enemy.visible = YES;type = 2;                 
        if(bubble.visible == YES) 
        {bubble.visible = NO;}
    } 
    
    if(height > startSpace) { enemy.visible = NO; type = 3; } 
    
    if(height > startHeaven) { if(enemyemitter.visible == YES) { enemyemitter.visible = NO; enemy.meteorActive = NO; }}
    
    // heaven/god
    if(height > startGod) { enemy.visible = YES; type = 4; }
    
	[enemy effect:type];
}

- (void) gameMovementPowerup
{
	if (difference < 0)
    {
		pu.position = ccp(pu.position.x, pu.position.y + difference); 
    }
    
    if(pu.position.y < -80 && pu.visible)
    {
        ptime = 0;
        [pu reset];
    }
}

- (void) gameMovementPlatform
{
	if (difference < 0)
		for(int i = 0; i < platformCount; i++) 
			platform[i].position = ccp(platform[i].position.x, platform[i].position.y + difference);
	
	for(int i = 0; i < platformCount; i++)
		if(platform[i].fallingMarker) 
		{ 
			platform[i].position = ccp(platform[i].position.x, platform[i].position.y - platform[i].velocity.y); 
			platform[i].velocity = ccp(platform[i].velocity.x, platform[i].velocity.y + gravity);
		}
	if(challengeMode) 
		fireLayer.position = ccp(fireLayer.position.x, fireLayer.position.y + 0.2);
}

- (void) gameMovementBG
{
	if (difference < 0)
	{
		for(int i = 0; i < bgcount; i++) 
		{
			bg[i].position = ccp(bg[i].position.x, bg[i].position.y + difference/bgspeed);
			if(bg[i].position.y < 0 - 1197) 
				bg[i].visible = NO;
        }
		gameFloor.position = ccp(gameFloor.position.x, gameFloor.position.y	+ difference); 		
	}
}

- (void) gameIntersects
{
    if(!challengeMode)[self gameIntersectsEnemy];
	[self gameIntersectsPlatform];
	[self gameIntersectsPowerup];
	[self gameIntersectsOther];
}

- (void) gameIntersectsEnemy
{
	if(CGRectIntersectsRect([devil getBoundingRect], [enemy getBoundingRect]) && pue.effect != @"boost" && enemy.enemyType != 1 && enemy.enemyType != 4)
    {
        if(!enemy.dead)
        {
            if(jumpVelocity.y < jumpPower) {
                if(jumpVelocity.y < 0)
                    jumpVelocity.y = + jumpPower;
                else
                    jumpVelocity.y = 1;
                
                CCBlink *blink = [CCBlink actionWithDuration:1.0 blinks:3];
                [devil runAction:blink];
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"bat-dead.mp3"];	
                
                enemyemitter = [[CCParticleExplosion alloc] initWithFile:@"smoke.plist"];
                enemyemitter.position = ccp(enemy.position.x,enemy.position.y); 
                [self addChild:enemyemitter z:2];
                [enemyemitter setAutoRemoveOnFinish:YES];            
                [enemyemitter autorelease];            
                
                enemy.visible = NO;
                
                [enemy kill];
            }
        }
    }
}

- (void) gameIntersectsPlatform
{
	for (int i = 0; i < platformCount; i++)
	{
        
        if(enemy.meteorActive == YES) { 
            if(CGRectIntersectsRect([enemyemitter boundingBox],[platform[i] getBoundingRect])) {
                [platform[i] touched];
            }
        }
        
        if(emitter != NULL && !emitter.active) { [self removeChild:emitter cleanup:YES]; emitter = NULL; } 
        if(platform[i].position.y < screenHeight) {
            if(CGRectIntersectsRect([devil getBoundingRect],[platform[i] getBoundingRect]) && pue.effect != @"boost") 
            {			
                if(platform[i].dead == NO && [platform[i] touched])
                {
                    if(devil.position.y < screenHeight - 30) {
                        if (resuming == YES) { 
                            resuming = NO; 
                            devil.dropping = NO; devil.dropin = NO; devil.positionAtTop = YES; dtime = 0;
                        } 
                        if(jumpVelocity.y < jumpPower) 
                        {
                            jumpVelocity.y = jumpPower;
                            [[SimpleAudioEngine sharedEngine] playEffect:platformSFX_chal];
                        }
                        
                        if(challengeMode) 
                        {
                            fireLayer.position = ccp(fireLayer.position.x, fireLayer.position.y - 3);
                        }
                    }
                }        
            }
        }
	}
    
    
	if(CGRectIntersectsRect([devil getBoundingRect],[gameFloor getBoundingRect])) 
	{
		jumpVelocity.y = gravity; 
		if (devil.lives == 0) [self endGame]; 
	}
	
	if(challengeMode) 
		if(CGRectIntersectsRect([devil getBoundingRect], [fireLayer boundingBox])) 
		{
			jumpVelocity.y = gravity; 
			[self endGame]; 
		}
}

- (void) gameIntersectsPowerup
{
	if(pu.visible) {
        if(CGRectIntersectsRect([devil getBoundingRect], [pu getBoundingRect])) 
        {
            [pue start:pu.effect];
            if(pue.effect == @"boost") [[SimpleAudioEngine sharedEngine] playEffect:@"up.wav"];
            [pu reset];
            ptime = 0;
            etime = 0;
        }
    }
}

- (void) gameIntersectsOther
{
    if(CGRectIntersectsRect([devil getBoundingRect],[bouncycastle getCustomRect]))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"toing-01-bass.mp3"];	
        if(bouncycastle.imageSwapped == NO) {
            imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"bouncy-castle-warp.png"]]; 
            [bouncycastle setTexture: imageSwap];                
            bouncycastle.imageSwapped = YES; 
            [imageSwap release];
        }
        jumpVelocity.y = + (jumpPower + 4);
    }
    if(bouncycastle.imageSwapped == YES && devil.position.y > 180) {
        imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"bouncycastle-bg.png"]]; 
        [bouncycastle setTexture: imageSwap]; 
        [imageSwap release];
        bouncycastle.imageSwapped = NO; 
    }
    if(!challengeMode) {
        if(enemy.birdPoopActive == YES) {
            if( CGRectIntersectsRect([devil getBoundingRect],[birdPoop getBoundingRect]))
            {
                if(birdPoop.visible == YES) {
                    birdPoop.visible = NO;    
                    
                    CCBlink *blink = [CCBlink actionWithDuration:1.0 blinks:3];
                    [devil runAction:blink];
                    beactive = YES; 
                    btype = 1; 
                    btime = 0; 
                }
            }
        }
        
        if(enemy.bubbleActive == YES) {
            if( CGRectIntersectsRect([devil getBoundingRect],[bubble getBoundingRect]))
            {
                if(bubble.visible == YES) {
                    bubble.visible = NO;    
                    beactive = YES; 
                    btype = 0; 
                    btime = 0; 
                    
                }
            }
        }
    }
    
    
}

- (void) gameGenerate
{
    if(!challengeMode) [self gameGenerateEnemy];
	[self gameGeneratePlatform];	
	if(ptime == ptimer)[self gameGeneratePowerup];
}

- (void) gameGenerateEnemy
{
	if(enemy.position.y < -30) [enemy regenerate:0];			
}

- (void) gameGeneratePowerup
{
    if(!pu.visible)
    {
        [pu generate:[pu typepicker] challengemode:challengeMode];        
        ptime = 0;
    }
}

- (void) gameGeneratePlatform
{
	int maxheight = 0; 
	for (int i = 0; i < platformCount; i++) 
		if(platform[i].position.y > maxheight) maxheight = platform[i].position.y;
	
	for (int i = 0; i < platformCount; i++) 
	{
		// if off screen, reset
		float viewWidth = screenWidth; 
		float fViewWidthMinusPlatformWidth = viewWidth - 75.0f;
		int iViewWidthMinusPlatformWidth = (int)fViewWidthMinusPlatformWidth; 		
		if(platform[i].position.y < 0) 
		{
			platform[i].fallingMarker = 0;
			platform[i].dead = 0;
			platform[i].visible = YES;
			
			float x = random() % iViewWidthMinusPlatformWidth; 
			x = x + 22.5f; 
            
			float y = maxheight + mingap + (random() % maxoffset);
			if(y < 510) y = 510; 
			if(pu.visible)
				if(CGRectIntersectsRect(platformRect[i], [pu getBoundingRect]))
					pu.position = ccp(platform[i].position.x + 40, platform[i].position.y + 40);
			
			platform[i].position = ccp(x,y);
			platform[i].velocity = ccp(0,0);
            CCTexture2D *imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"hell-platform.png"]];
            [platform[i] setTexture: imageSwap];
            [imageSwap release];
		}
	}	
}

- (void) gameEffects
{
    if(pue.active) [self gameEffectsPowerup];
    if(beactive) [self gameBadEffects:btype];
    
    if(godpoweractive) [self gameGodEffects:godpower];
}

- (void) gameGodEffects:(int)gptype
{
    switch(gptype)
    {
        case 1:
            if(btime < 5) 
            {
                if(godpowerEffectActive == NO) {
                    devil.scaleX = 0.5f;  
                    devil.scaleY = 0.5f;
                    CCTexture2D *GodSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"God-point.png"]];
                    [enemy setTexture: GodSwap];
                    [GodSwap release];
                    godpowerEffectActive = YES;
                }
            }
            else {
                devil.scaleX = 1.0f;
                devil.scaleY = 1.0f;
                btime = 0;
                godpowerEffectActive = NO;
                godpoweractive = NO; 
                CCTexture2D *GodSwapRevert = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"God.png"]];
                [enemy setTexture: GodSwapRevert];
                [GodSwapRevert release];
            }
            break;
        case 2:
            if(btime < 5)
            {
                if(godpowerEffectActive == NO) {
                    for (int i = 0; i < platformCount; i++) 
                    {
                        platform[i].scaleX = 0.5f;
                        platform[i].scaleY = 0.5f;
                    }
                    CCTexture2D *GodSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"God-point.png"]];
                    [enemy setTexture: GodSwap];
                    [GodSwap release];
                    godpowerEffectActive = YES; 
                }
            }
            else {
                for (int i = 0; i < platformCount; i++) 
                {
                    platform[i].scaleX = 1.0f;
                    platform[i].scaleY = 1.0f;
                }
                btime = 0;
                godpoweractive = NO; 
                CCTexture2D *GodSwapRevert = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"God.png"]];
                [enemy setTexture: GodSwapRevert];
                [GodSwapRevert release];
                godpowerEffectActive = NO;
            }
    }
}

- (void) gameEffectsPowerup
{
    if(etime < 1 && pue.effect == @"boost") {
        jumpVelocity.y  = 45;
    }
    else if(etime < 10 && pue.effect == @"bounce") {
        bouncycastle.position = ccp(bouncycastle.position.x, 65);
        
        if(etime == 7) { 
            [bouncycastle blink:1];
        }
        if(etime == 8) { 
            [bouncycastle blink:3];
        }
        if(etime == 9) { 
            [bouncycastle blink:5];
        }
    }
    else if(etime < 2 && pue.effect == @"freeze")  {
        fireLayer.position = ccp(fireLayer.position.x, fireLayer.position.y - 1.5);
        [fireLayer setColor:ccc3(76,96,168)];
    }
    else {
        // Reset Bouncy Castle
        bouncycastle.position = ccp(bouncycastle.position.x, -100);
        [self removeChild:bcfx cleanup:YES];
        
        // Reset Freeze
        if(challengeMode) [fireLayer setColor:ccc3(255, 0, 0)];
        
        // Reset All
        pue.active = NO;
        etime = 0; 
        pue.effect = @"";
    }
}

- (void) gameBadEffects:(int)betype {
    switch(betype)
    {
        case 0:
            if(btime <= 3) { 
                if(devil.imageSwapped == NO) { 
                    bubbleimageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"devil-bubble.png"]]; 
                    [devil setTexture: bubbleimageSwap];
                    [bubbleimageSwap autorelease];
                    devil.imageSwapped = YES; 
                    devil.textureRect = CGRectMake(0,0,80,80);
                }
            }
            else { 
                bubbleimageSwapRevert = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"Devil.png"]]; 
                [devil setTexture: bubbleimageSwapRevert];
                [bubbleimageSwapRevert autorelease];
                devil.imageSwapped = NO; 
                devil.textureRect = CGRectMake(0,0,50,56);
                
                beactive = NO;
                btime = 0; 
            }
            break;
            
            // Bird
        case 1:
            if(btime <= 1.5) {
                if(devil.imageSwapped == NO) { 
                    int randomSplat = random() %4; 
                    if(randomSplat == 0) randomSplat = random() % 4;
                    if(randomSplat == 0) randomSplat = 3;
                    NSString *randomSplatter = [NSString stringWithFormat:@"splatter%d.png",randomSplat];
                    splatter = [CCSprite spriteWithFile:randomSplatter];
                    [splatter setPosition:ccp(screenWidth/2, screenHeight/2)];
                    [self addChild:splatter z:211];
                    devil.imageSwapped = YES; 
                }
            }
            else {
                [self removeChild:splatter cleanup:YES];
                beactive = NO;
                btime = 0; 
                devil.imageSwapped = NO; 
            }
            break;
        case 4: 
            if(godpoweractive == NO) {
                if(btime >= 10) { 
                    godpowerType = random() % 3;
                    if(godpowerType == 0) godpowerType = random() % 3;
                    if(godpowerType == 0) godpowerType = 1;            
                    
                    switch(godpowerType) {
                        case 1: 
                            godpower = 1; 
                            godpoweractive = YES; 
                            btime = 0; 
                            break; 
                        case 2:     
                            godpower = 2; 
                            godpoweractive = YES;
                            btime = 0; 
                            break;
                        case 3:
                            godpower = 3;
                            godpoweractive = YES;
                            btime = 0;
                            break;
                    }
                }
            }
            
            break;
        default:
            break;
    }
}

- (void) gameScores
{
	if (difference < 0) 
	{
		if(!challengeMode)
		{
			if(resuming == NO) {
                NSString *updateScore = [NSString stringWithFormat:@"Current: %dm",difToInt/10]; 
                [scoreCounter setString:updateScore];
                scoreCounter.position = ccp((screenWidth - scoreCounter.contentSize.width/2) - 5, scoreCounter.position.y);
            }
		}		
	} 
	
	if(challengeMode == YES)
	{
		NSString *updateScore = [NSString stringWithFormat:@"Current: %ds",scoreInt]; 
		[scoreCounter setString:updateScore];
		scoreCounter.position = ccp((screenWidth - scoreCounter.contentSize.width/2) - 5, scoreCounter.position.y);			
	}		
}



/********************************************************************************************************************************/
// INIT METHODS
/********************************************************************************************************************************/
- (void) initAudio
{
	[CDAudioManager sharedManager].mute = [[NSUserDefaults standardUserDefaults] boolForKey:@"muted"]; 
	if([CDAudioManager sharedManager].mute < 0) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"muted"];
		[CDAudioManager sharedManager].mute	= NO;
	}
}

- (void) initButtons
{
	CCMenuItemImage *pauseBtn = [CCMenuItemImage
								 itemFromNormalImage:pauseIMG_chal
								 selectedImage:pauseIMG_chal
								 target:self
								 selector:@selector(pauseGame:)];
	CCMenu *pauseMenu = [CCMenu menuWithItems: pauseBtn, nil];
	[pauseMenu setPosition:ccp(20,460)];
	[self addChild: pauseMenu z:10];
}

-(void)initChallenge 
{
	fireLayer = [CCColorLayer layerWithColor: ccc4(255, 0, 0, 220) width: screenWidth height: screenHeight];
	fireLayer.position = ccp(0,-(screenHeight + 50));
	[self addChild: fireLayer z:5];
	
	CCParticleExplosion *emitter = [[CCParticleExplosion alloc] initWithFile:@"challenge_fire.plist"];
	emitter.position = ccp(160,0);
    [emitter setAutoRemoveOnFinish:YES];    
	[self addChild:emitter z:2];
    [emitter autorelease];
}

- (void) initCharacters 
{
	devil = [Player spriteWithFile:devilIMG_chal rect:CGRectMake(0, 0, 50, 56)]; 
	[devil setPosition:ccp(140,40)];
	[self addChild:devil z:4];
	devil.imageSwapped = NO; 
	touchLocation = devil.position; 
    devil.dropin = NO;
    devil.dropping = NO; 
    devil.positionAtTop = YES;
}

- (void) initEnemies
{
    if(!challengeMode) {
        enemy = [Enemy spriteWithFile:@"bat.png" rect:CGRectMake(0,0,75,30)];
        [enemy setPosition:ccp(-100,3000)];
        [self addChild: enemy z:4]; 	
        enemy.ybase = 3000;
        enemy.imageSwapped = NO;
        enemy.enemyType = 0; 
        enemy.birdPoopActive = NO; 
        enemy.bubbleActive = NO; 
        enemy.meteorActive = NO; 
    }
}

- (void) initLabels 
{
	CCLabel *highscoreCounter = [CCLabel labelWithString:highScoreText fontName:font_chal fontSize:16];
	[highscoreCounter setPosition:ccp((screenWidth - highscoreCounter.contentSize.width/2) - 5,470)];
	[self addChild:highscoreCounter z:10];
	
	scoreCounter = [CCLabel labelWithString:currentScoreText fontName:font_chal fontSize:16];
	[scoreCounter setPosition:ccp((screenWidth - scoreCounter.contentSize.width/2) - 5,452)];
	[self addChild:scoreCounter z:10];
	
	int x = 300;
	int y = 400; 
	for(int l = 0; l <= 3; l++)
	{
		lifeCounter[l] = [CCSprite spriteWithFile:lifeIMG_chal];
		[lifeCounter[l] setPosition:ccp(x,y)];
		[self addChild:lifeCounter[l] z:10];
		y -= 38;
	}
    lifeCounter[3].visible = NO; 
    
    
    dropinNumber_chal = [NSString stringWithFormat:@"0"];
    
    dropinLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 100) width: screenWidth height: screenHeight];
    dropinLayer.position = ccp(0,0);
    [self addChild: dropinLayer z:11];
    dropinText = [CCLabel labelWithString:dropinNumber_chal fontName:font_chal fontSize:40];
    [dropinText setPosition:ccp(screenWidth/2,screenHeight/2)];
    [self addChild:dropinText z:12];
    
    dropinLayer.visible = NO;
    dropinText.visible = NO;
    
}

- (void) initPlatforms 
{
	int x = 0; 
    int y = 0; 
	for (int i = 0; i < platformCount; i++) 
	{
		platform[i] = [Platform spriteWithFile:platformIMG_chal rect:CGRectMake(0,0,24, 20)];
		
		if(i == 0) { x = 225; y = 390; }
		if(i == 1) { x = 50;  y = 300; }
		if(i == 2) { x = 100; y = 220; }
		if(i == 3) { x = 250; y = 325; }
		if(i == 4) { x = 85;  y = 125; }
		if(i == 5) { x = 300; y = 400; }
		if(i == 6) { x = 100; y = 430; }
		if(i == 7) { x = 200; y = 75;  }
		if(i == 8) { x = 195; y = 175; }
		
		platform[i].velocity = ccp(0,0);
		[platform[i] setPosition:ccp(x,y)];
		[self addChild:platform[i]  z:2];
	}
	gameFloor = [Platform spriteWithFile:floorIMG_chal rect:CGRectMake(0,0,320,8)];
	[gameFloor setPosition:ccp(160,4)];
	[self addChild:gameFloor  z:2];	
}

- (void) initPowerups
{
	pu = [Powerup spriteWithFile:@"powerup-boost.png" rect:CGRectMake(0,0,50,50)];
	[pu setPosition:ccp(screenWidth/2,340)];
	[self addChild:pu z:3];
	pu.xbase = screenWidth/2; 
    pu.visible = NO;
    
    pue = [PowerupEffect spriteWithFile:@"powerup-boost.png"];
    [pue setPosition:ccp(-100,-100)];
    [self addChild:pue];
    
    bouncycastle = [PowerupEffect spriteWithFile:@"bouncycastle-bg.png"];                       
    [bouncycastle setPosition:ccp(screenWidth/2,-150)];
    [self addChild:bouncycastle z:3];
}

- (void) initScore
{
	if(challengeMode) 
	{
		if(![[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_challenge"]) 
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore_challenge"];
		
		highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_challenge"];
		
		highScoreText = [NSString stringWithFormat:@"Highest: %ds",highScore]; 
		currentScoreText = [NSString stringWithFormat:@"Current: %ds",0]; 
        
	}
	
	else 
	{
		if(![[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]) 
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore"];
		
		highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
		
		highScoreText = [NSString stringWithFormat:@"Highest: %dm",highScore]; 
		currentScoreText = [NSString stringWithFormat:@"Current: %dm",0]; 
		
	}
}

- (void) initWorld
{
	int x = 160;
	int y = 600;
	for(int i = 0; i < bgcount; i++) 
	{
		NSString *bgName = [NSString stringWithFormat:@"bg%d.png",i]; 
		bg[i] = [CCSprite spriteWithFile:bgName];
		[bg[i] setPosition:ccp(x,y)];
		[self addChild:bg[i] z:1];
		y += 1197;
        [bg[i].texture setAliasTexParameters];
	}
	jumpVelocity = ccp(0,0);
}


/********************************************************************************************************************************/
// TIMER METHODS
/********************************************************************************************************************************/

- (void) timerScore: (ccTime)dt
{
    scoreInt++;
}

- (void) timerPower: (ccTime)dt
{
    ++ptime;
}

- (void) timerEffect: (ccTime)dt
{
    ++etime; 
}

- (void) timerBadEffect: (ccTime)dt
{
    ++btime; 
}

- (void) timerDropin: (ccTime)dt
{
    ++dtime; 
}


/********************************************************************************************************************************/
// TOUCH METHODS
/********************************************************************************************************************************/
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{
	if(![CCDirector sharedDirector].isPaused) 
	{
		CGPoint location = [touch locationInView: [touch view]];
		touchLocation = location; 
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
	if(![CCDirector sharedDirector].isPaused) 
	{
		// DOUBLE TAP TO JUMP
		if(touch.tapCount == 2 && devil.lives > 0  && resuming == NO) 
		{
			// INIT JUMP USING JUMPPOWER
			if(gameStarted != NO && touch.tapCount == 2)
			{
				jumpVelocity.y = +jumpPower + 2;
				devil.lives--;
				lifeCounter[devil.lives].visible = NO;
			}
			else 
			{
				jumpVelocity.y = +jumpPower + 2;
				gameStarted = YES; 
			}
		}
	}
	else {
		[[CCDirector sharedDirector] resume];
		if(pauseLayer.visible) 
		{
			[self removeChild:pauseLayer cleanup:YES];
			[self removeChild:pauseText cleanup:YES];
			
			[self removeChild:mutemenu cleanup:YES];
		}
	}
}
/********************************************************************************************************************************/
// BUTTON/MENU METHODS
/********************************************************************************************************************************/
- (void) mute: (id) sender
{
	if ([CDAudioManager sharedManager].mute == NO) 
	{
		[CDAudioManager sharedManager].mute = YES;
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"muted"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else 
	{
		[CDAudioManager sharedManager].mute = NO;
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"muted"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}
- (void) mainMenu: (id) sender
{
		[[CCDirector sharedDirector] replaceScene:[MainMenu_challenge scene]];
}

- (void) restartGame: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[Gameplay_Challenge scene]];
}

/********************************************************************************************************************************/
// GAMESTATE METHODS
/********************************************************************************************************************************/
- (void) pauseGame: (id) sender
{
	if(![CCDirector sharedDirector].isPaused) 
	{
		[[CCDirector sharedDirector] pause];
		pauseLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 100) width: screenWidth height: screenHeight];
		pauseLayer.position = ccp(0,0);
		[self addChild: pauseLayer z:11];
		
		pauseText = [CCLabel labelWithString:@"PAUSED" fontName:font_chal fontSize:40];
		[pauseText setPosition:ccp(screenWidth/2,screenHeight/2)];
		[self addChild:pauseText z:12];		
		
	}
}
- (void) endGame
{
	[[CCDirector sharedDirector] pause];
    
	devil.visible = NO;
	pauseLayer = [CCColorLayer layerWithColor: ccc4(0, 0, 0, 200) width: screenWidth height: screenHeight];
	pauseLayer.position = ccp(0,0);
	[self addChild: pauseLayer z:11];
	
	CCSprite *deadScreen = [CCSprite spriteWithFile:deadIMG_chal];
	[deadScreen setPosition:ccp(screenWidth/2,screenHeight/2)];
	[self addChild:deadScreen z:13];
	
	CCMenuItemImage *mainmenu = [CCMenuItemImage
								 itemFromNormalImage:mainmenuIMG_chal
								 selectedImage:mainmenuIMG_chal
								 target:self
								 selector:@selector(mainMenu:)];
	CCMenu *deadmenu1 = [CCMenu menuWithItems: mainmenu, nil];
	[deadmenu1 setPosition:ccp(167,115)];
	[self addChild:deadmenu1 z:14];
	
	CCMenuItemImage *restartbtn = [CCMenuItemImage
								   itemFromNormalImage:restartmenuIMG_chal
								   selectedImage:restartmenuIMG_chal
								   target:self
								   selector:@selector(restartGame:)];
	CCMenu *deadmenu2 = [CCMenu menuWithItems: restartbtn, nil];
	[deadmenu2 setPosition:ccp(255,115)];
	[self addChild:deadmenu2 z:14];
	
	if(challengeMode)
	{
		NSString *endScoreText = [NSString stringWithFormat:@"%ds",scoreInt];
		CCLabel *endScore = [CCLabel labelWithString:endScoreText fontName:font_chal fontSize:20];
		[endScore setPosition:ccp(138,186)];
		[self addChild:endScore z:14];
		
		
		if(scoreInt > [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_challenge"])
		{
			[[NSUserDefaults standardUserDefaults] setInteger:scoreInt forKey:@"highScore_challenge"];
			[[NSUserDefaults standardUserDefaults] synchronize];
            
            if([[[UIDevice currentDevice] systemVersion] compare:@"4.2" options:NSNumericSearch] == NSOrderedDescending)
            {
                GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];            
                if(localPlayer.isAuthenticated) 
                {
                    [self reportScore:scoreInt forCategory:@"ldboard2"];   
                }
            }
		}
	}
	else
	{
		int score = difToInt/10; 
		
		NSString *endScoreText = [NSString stringWithFormat:@"%dm",score];
		CCLabel *endScore = [CCLabel labelWithString:endScoreText fontName:font_chal fontSize:20];
		[endScore setPosition:ccp(145,186)];
		[self addChild:endScore z:14];
		
		
		if(score > [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"])
		{
			[[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"highScore"];
			[[NSUserDefaults standardUserDefaults] synchronize];
            
            if([[[UIDevice currentDevice] systemVersion] compare:@"4.2" options:NSNumericSearch] == NSOrderedDescending)
            {
                GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];            
                if(localPlayer.isAuthenticated) 
                {
                    [self reportScore:score forCategory:@"ldboard1"];   
                }
            }
		}
	}
}

/* GAME CENTER STUFF */
- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // handle the reporting error
        }
    }];
}

/********************************************************************************************************************************/
// END GAME
/********************************************************************************************************************************/

- (void) resetNumbers {
	devil.lives = 3;
	gameStarted = NO;
	difToInt = 0;
	if(challengeMode) scoreInt = 0;
    etime = 0;
    ptime = 0;
    btime = 0;
    top = NO;
    beactive = NO; 
    godpower = 0; 
    godpowerType = 0; 
    godpowerEffectActive = NO; 
    dtime = 0;
    resuming = NO;
    dropinActive = NO;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end