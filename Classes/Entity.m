//
//  Entity.m
//  LittleDevil
//
//  Created by Andy Girvan on 08/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"


@implementation Entity
@synthesize ybase, xbase;

-(CGRect) getBoundingRect {
	CGSize size = [self contentSize]; 
	size.width  *= scaleX_; 
	size.height *= scaleY_; 
	return CGRectMake(position_.x - size.width * anchorPoint_.x,
					  position_.y - size.height * anchorPoint_.y,
					  size.width, size.height); 
}

-(CGRect) getCustomRect { 
    CGSize size = [self contentSize]; 
	size.width  *= scaleX_; 
	size.height *= scaleY_; 
	return CGRectMake(position_.x - size.width * anchorPoint_.x,
					  position_.y - size.height * anchorPoint_.y,
					  size.width, size.height - 106.0f); 
}

- (void) dealloc
{
    [super dealloc];
}

@end
