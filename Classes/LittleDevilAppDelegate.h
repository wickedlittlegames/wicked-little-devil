//
//  LittleDevilAppDelegate.h
//  LittleDevil
//
//  Created by Andy Girvan on 08/11/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

@interface LittleDevilAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;
-(void)authenticateLocalPlayer;

@end
