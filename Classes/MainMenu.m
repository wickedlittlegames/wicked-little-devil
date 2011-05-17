//
//  MainMenu.m
//  LittleDevil
//
//  Created by Andy Girvan on 09/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "MainMenu.h"

#import "AppSpecificValues.h"
#import "GameSpecificValues.h"


#import "MainMenu_challenge.h"
#import "Gameplay.h"
#import "SimpleAudioEngine.h"

@implementation MainMenu
@synthesize menuchallengeMode; 

NSURL *url;

+(id) scene
{
	CCScene *scene = [CCScene node];
	MainMenu *layer = [MainMenu node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) 
	{
		[self initAudio];
		[self initScore];
		[self initMenus];
	}
	return self;
}

- (void) initAudio
{
	[CDAudioManager sharedManager].mute = [[NSUserDefaults standardUserDefaults] boolForKey:@"muted"]; 
	if([CDAudioManager sharedManager].mute < 0) 
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"muted"];
		[CDAudioManager sharedManager].mute	= NO;
	}	
}

- (void) initScore
{
	int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]; 
	if(highScore < 0) 
	{
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore"];
		highScore = 0;
	}
	
	NSString *highScoreString = [NSString stringWithFormat:@"%dm",highScore]; 
	CCLabel *highScoreLabel = [CCLabel labelWithString:@"0" fontName:@"Futura" fontSize:28];
	highScoreLabel.color = ccc3(0,0,0); 
	[highScoreLabel setPosition:ccp(225,275)];
    // was 310
	[self addChild:highScoreLabel z:100];		
	
	[highScoreLabel setString:highScoreString];	
}

- (void) initMenus
{
	CCSprite *bg = [CCSprite	spriteWithFile:@"Wicked-Toggle-Menu-Screen.png"];
	[bg setPosition:ccp(160,240)];
	[self addChild:bg z:0];
    
    CCMenuItemImage *tweetButton = [CCMenuItemImage
									itemFromNormalImage:@"tweet.png"
									selectedImage:@"tweet.png"
									target:self
									selector:@selector(tweetThis:)];
	CCMenu *tweet = [CCMenu menuWithItems: tweetButton, nil];
	[tweet setPosition:ccp(300,235)];
	[self addChild: tweet z:51];
    
    /*CCMenuItemImage *fbButton = [CCMenuItemImage
									itemFromNormalImage:@"facebook-icon.png"
									selectedImage:@"facebook-icon.png"
									target:self
									selector:@selector(fbThis:)];
	CCMenu *fb = [CCMenu menuWithItems: fbButton, nil];
	[fb setPosition:ccp(275,235)];
	[self addChild: fb z:51];*/

    
	
	CCMenuItemImage *startButton = [CCMenuItemImage
									itemFromNormalImage:@"Start-button.png"
									selectedImage:@"Start-button-selected.png"
									target:self
									selector:@selector(startGame:)];
	CCMenu *menu = [CCMenu menuWithItems: startButton, nil];
	[menu setPosition:ccp(119,73)];
	[self addChild: menu z:51];
	
	
	CCMenuItemImage *muteButton = [CCMenuItemImage
								   itemFromNormalImage:@"mute-soundon.png"
								   selectedImage:@"mute-soundon.png"
								   target:self
								   selector:@selector(mute:)];
	CCMenu *mutemenu = [CCMenu menuWithItems: muteButton, nil];
	[mutemenu setPosition:ccp(22,25)];
	[self addChild: mutemenu z:51];
    
    CCMenuItemImage *infoButton = [CCMenuItemImage
								   itemFromNormalImage:@"info.png"
								   selectedImage:@"info.png"
								   target:self
								   selector:@selector(infoscreen:)];
	CCMenu *infoMenu = [CCMenu menuWithItems: infoButton, nil];
	[infoMenu setPosition:ccp(58,25)];
	[self addChild: infoMenu z:51];
	
	CCMenuItemImage *challenge = [CCMenuItemImage
								  itemFromNormalImage:@"mode-normal.png"
								  selectedImage:@"mode-normal.png"
								  target:self
								  selector:@selector(menuChallenge:)];
	CCMenu *menuchallenge = [CCMenu menuWithItems: challenge, nil];
	[menuchallenge setPosition:ccp(88,195)];
	[self addChild:menuchallenge z:51];
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
	CCScene *sceneNew = [CCScene node];
	Gameplay *layerNew = [Gameplay node];
	layerNew.challengeMode = NO;
	[layerNew buildGame]; 
	[sceneNew addChild: layerNew];
	
	[[CCDirector sharedDirector] replaceScene:sceneNew];
}
- (void) menuStandard: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}
- (void) menuChallenge: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[MainMenu_challenge scene]];
}

- (void) tweetThis: (id) sender
{
    int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]; 
	if(highScore < 0) 
	{
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore"];
		highScore = 0;
	}
	
	NSString *highScoreString = [NSString stringWithFormat:@"http://twitter.com/?status=My #littledevil climbed %dm out of Hell - can you beat that? http://bit.ly/littledevil",highScore]; 
    NSString* escapedUrlString = [highScoreString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

    url = [[NSURL alloc] initWithString:escapedUrlString];    
    [[UIApplication sharedApplication] openURL:url];
    [url release];

}
/*
- (void) fbThis: (id) sender
{
    int highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]; 
	if(highScore < 0) 
	{
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"highScore"];
		highScore = 0;
	}
	
	NSString *highScoreString = [NSString stringWithFormat:@"http://facebook.com/?status=My #littledevil climbed %dm out of Hell - can you beat that? http://bit.ly/littledevil",highScore]; 
    NSString* escapedUrlString = [highScoreString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    url = [[NSURL alloc] initWithString:escapedUrlString];    
    [[UIApplication sharedApplication] openURL:url];
    
}
*/

- (void) infoscreen: (id) sender
{
    CCMenuItemImage *infoscreenButton = [CCMenuItemImage
                                   itemFromNormalImage:@"infoscreen.png"
                                   selectedImage:@"infoscreen.png"
                                   target:self
                                   selector:@selector(menuStandard:)];
    CCMenu *infoscreenMenu = [CCMenu menuWithItems: infoscreenButton, nil];		
    [infoscreenMenu setPosition:ccp(160,240)];
    [self addChild: infoscreenMenu z:302];
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
