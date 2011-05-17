//
//  Enemy.h
//  LittleDevil
//
//  Created by Andy Girvan on 27/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"

@interface Enemy : Entity {
    bool dead, imageSwapped,moving,birdPoopActive,bubbleActive,meteorActive,godActive;
    int enemyType, direction; 
}

@property (nonatomic) bool dead,imageSwapped,moving,birdPoopActive,bubbleActive,meteorActive,godActive; 
@property (nonatomic) int enemyType,direction; 
-(void)effect:(int)type;
-(void)regenerate:(int)type;
-(void)kill;
-(void)spriteMoveFinished: (id) sender;
@end
