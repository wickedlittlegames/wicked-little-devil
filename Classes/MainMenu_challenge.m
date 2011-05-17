//
//  MainMenu_challenge.m
//  LittleDevil
//
//  Created by Andy Girvan on 09/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "MainMenu.h"
#import "MainMenu_challenge.h"

#import "Gameplay.h"
#import "SimpleAudioEngine.h"


@implementation MainMenu_challenge
@synthesize menuchallengeMode; 

NSURL *url;

+(id) scene
{
	CCScene *scene = [CCScene node];
	MainMenu_challenge *layer = [MainMenu_challenge node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) 
	{
		[CDAudioManager sharedManager].mute = [[NSUserDefaults standardUserDefaults] boolForKey:@"muted"]; 
		if([CDAudioManager sharedManager].mute < 0) 
		{
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"muted"];
			[CDAudioManager sharedManager].mute	= NO;
		}

		int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_challenge"]; 
		if(highScore < 0) {
			[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore_challenge"];
			highScore = 0;
		}
		
		NSString *highScoreString = [NSString stringWithFormat:@"%dsecs",highScore]; 
		
		CCLabel *highScoreLabel = [CCLabel labelWithString:@"0" fontName:@"Futura" fontSize:28];
		highScoreLabel.color = ccc3(0,0,0); 
		[highScoreLabel setPosition:ccp(225,275)];
		[self addChild:highScoreLabel z:100];		
		[highScoreLabel setString:highScoreString];
		
        CCSprite *bg = [CCSprite	spriteWithFile:@"Wicked-Toggle-Menu-Screen.png"];
		[bg setPosition:ccp(160,240)];
		[self addChild:bg z:0];
		
		CCMenuItemImage *startButton = [CCMenuItemImage
										itemFromNormalImage:@"Start-button.png"
										selectedImage:@"Start-button-selected.png"
										target:self
										selector:@selector(startGame:)];
		CCMenu *menu = [CCMenu menuWithItems: startButton, nil];
        [menu setPosition:ccp(119,73)];
		[self addChild: menu z:51];
		
        
        CCMenuItemImage *tweetButton = [CCMenuItemImage
                                        itemFromNormalImage:@"tweet.png"
                                        selectedImage:@"tweet.png"
                                        target:self
                                        selector:@selector(tweetThis:)];
        CCMenu *tweet = [CCMenu menuWithItems: tweetButton, nil];
        [tweet setPosition:ccp(300,235)];
        [self addChild: tweet z:51];

		
		CCMenuItemImage *muteButton = [CCMenuItemImage
										itemFromNormalImage:@"mute-soundon.png"
										selectedImage:@"mute-soundon.png"
										target:self
										selector:@selector(mute:)];
		CCMenu *mutemenu = [CCMenu menuWithItems: muteButton, nil];
		[mutemenu setPosition:ccp(22,25)];
		[self addChild: mutemenu z:51];
		
		CCParticleExplosion *emitter = [[CCParticleExplosion alloc] initWithFile:@"challenge_fire.plist"];
		emitter.position = ccp(160,0);
        [emitter setAutoRemoveOnFinish:YES];                        
		[self addChild:emitter z:50];
        [emitter autorelease];


		CCMenuItemImage *infoButton = [CCMenuItemImage
                                       itemFromNormalImage:@"info.png"
                                       selectedImage:@"info.png"
                                       target:self
                                       selector:@selector(infoscreen:)];
        CCMenu *infoMenu = [CCMenu menuWithItems: infoButton, nil];
        [infoMenu setPosition:ccp(58,25)];
        [self addChild: infoMenu z:51];
        
		CCMenuItemImage *freeplay = [CCMenuItemImage
									  itemFromNormalImage:@"mode-challenge.png"
									  selectedImage:@"mode-challenge.png"
									  target:self
									  selector:@selector(menuNormal:)];
		CCMenu *menufreeplay = [CCMenu menuWithItems: freeplay, nil];
		[menufreeplay setPosition:ccp(96,190)];	

		[self addChild:menufreeplay z:51];
	}
	return self;
}

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

- (void) startGame: (id) sender
{
	CCScene *scene = [CCScene node];
	Gameplay *layer = [Gameplay node];
	layer.challengeMode = YES;
	[layer buildGame]; 
	[scene addChild: layer];
	
	[[CCDirector sharedDirector] replaceScene:scene];	
}


- (void) infoscreen: (id) sender
{
    CCMenuItemImage *infoscreenButton = [CCMenuItemImage
                                         itemFromNormalImage:@"infoscreen.png"
                                         selectedImage:@"infoscreen.png"
                                         target:self
                                         selector:@selector(menuChallenge:)];
    CCMenu *infoscreenMenu = [CCMenu menuWithItems: infoscreenButton, nil];		
    [infoscreenMenu setPosition:ccp(160,240)];
    [self addChild: infoscreenMenu z:302];
}


- (void) menuNormal: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[MainMenu	scene]];
}

- (void) menuChallenge: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[MainMenu_challenge scene]];
}

- (void) tweetThis: (id) sender
{
    int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore_challenge"]; 
    if(highScore < 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore_challenge"];
        highScore = 0;
    }
	
	NSString *highScoreString = [NSString stringWithFormat:@"http://twitter.com?status=My #littledevil lasted %dsecs in Hell - can you beat that? http://bit.ly/littledevil",highScore]; 
    NSString* escapedUrlString = [highScoreString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    url = [[NSURL alloc] initWithString:escapedUrlString];    
    [[UIApplication sharedApplication] openURL:url];
    
    [url release];
    
    
}




// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [url dealloc];

	[super dealloc];
}


@end
