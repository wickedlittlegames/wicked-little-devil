//
//  LittleDevilAppDelegate.m
//  LittleDevil
//
//  Created by Andy Girvan on 08/11/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "LittleDevilAppDelegate.h"
#import "MainMenu.h"
#import "MainMenu_challenge.h"

@implementation LittleDevilAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//

	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
    //[director setAnimationInterval:1.0/60];
	//[director setDisplayFPS:YES];
    
    

	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];

	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
    if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"theme song.m4a" loop:YES];	
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.2;
    }
    if([[[UIDevice currentDevice] systemVersion] compare:@"4.2" options:NSNumericSearch] == NSOrderedDescending)
        [self authenticateLocalPlayer];
    
	[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if( ![CCDirector sharedDirector].isPaused ) {
        [[CCDirector sharedDirector] resume];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}


- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            
        }
    }];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
