//
//  Platform.h
//  LittleDevil
//
//  Created by Andy Girvan on 11/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"

@interface Platform : Entity {
	int fallingMarker; 
	CGPoint velocity;
	BOOL dead; 
}
@property (nonatomic) int fallingMarker;
@property (nonatomic) BOOL dead;
@property (nonatomic) CGPoint velocity; 

-(BOOL)touched; 

@end
