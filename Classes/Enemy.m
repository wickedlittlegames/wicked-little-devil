//
//  Enemy.m
//  LittleDevil
//
//  Created by Andy Girvan on 27/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy
@synthesize dead,imageSwapped,enemyType,moving,birdPoopActive,bubbleActive,meteorActive,direction, godActive;
CCTexture2D *imageSwap; 
CCSprite *birdPoop;

-(void)effect:(int)type 
{
	switch (type)
	{
        // bat
		case 0:
			self.position = ccp(self.position.x + 2, self.ybase + sin((self.position.x+2)/10) * 15); 
			if (self.position.x > 480+70) self.position = ccp(-30, self.position.y);
			break;
        
        // bubble
		case 1:
            self.visible = NO; 
            self.position = ccp(self.position.x + 0.5, 20);
            if (self.position.x > 480+70) self.position = ccp(-30, 20);
			break;
            
        // angry bird
        case 2:
            if(self.visible == NO) self.visible = YES; 
            if(self.imageSwapped == NO) { 
                imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"bird.png"]];
                [self setTexture: imageSwap];
                [imageSwap release];
                self.imageSwapped = YES; 
                self.textureRect = CGRectMake(0,0,70,38);
            }
            
            if(self.moving == NO) {
                self.moving = YES; 
                int randomPosition = random()%300;
                                
                id actionMove = [CCMoveTo actionWithDuration:1.0f position:ccp(randomPosition, self.position.y)];
                id actionFinish = [CCCallFunc actionWithTarget:self selector:@selector(spriteMoveFinished:)];
                [self runAction:[CCSequence actions:actionMove, actionFinish, nil]];
                
                if (self.position.x > randomPosition)	
                    [self runAction:[CCFlipX actionWithFlipX:YES]];
                else
                    [self runAction:[CCFlipX actionWithFlipX:NO]];

            }

            break;
        
        // meteor
        case 3: 
            if(self.meteorActive == NO) {
                if(self.visible == YES) self.visible = NO; 
                self.position = ccp(-100,-100);
            }
            break;
        
        // god
        case 4:
            if(self.godActive == NO) {
                self.position = ccp(320/2, 480/2); 
                imageSwap = [[CCTexture2D alloc] initWithImage:[UIImage imageNamed:@"God.png"]];
                [self setTexture: imageSwap];
                [imageSwap release];
                self.imageSwapped = YES; 
                self.textureRect = CGRectMake(0,0,320,480);

                if(self.visible == NO) self.visible = YES;
                self.godActive = YES; 
            }
            break;
		default:
			self.position = ccp(self.position.x + 20, self.position.y); 
			if (self.position.x > 480+70) self.position = ccp(-30, self.position.y);
			break;
	}
    self.enemyType = type; 
	
}

-(void)regenerate:(int)type
{
	switch (type)
	{
		case 0:
			self.position = ccp(-30, 2500 + (random() % 3500)); 
			self.ybase = self.position.y; 
            self.dead = NO; 
            self.visible = YES;
			break;
		default:
			self.position = ccp(-30, 2500 + (random() % 3500)); 
            self.dead = NO; 
            self.visible = YES; 
			break;
	}
}

-(void)kill
{
    self.dead = YES; 
}

-(void)spriteMoveFinished: (id) sender
{
    self.moving = NO; 
}

@end