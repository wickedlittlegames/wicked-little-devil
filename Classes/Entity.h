//
//  Entity.h
//  LittleDevil
//
//  Created by Andy Girvan on 08/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Entity : CCSprite {
	int ybase, xbase; 
}
-(CGRect) getBoundingRect;
-(CGRect) getCustomRect;
@property(nonatomic) int ybase, xbase; 

@end
