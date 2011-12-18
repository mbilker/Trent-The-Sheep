//
//  AboutScene.m
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutScene.h"
#import "HelloWorldLayer.h"

@implementation AboutScene
@synthesize layer = _layer;

- (id)init {
	
	if ((self = [super init])) {
		self.layer = [AboutLayer node];
		[self addChild:_layer];
	}
	return self;
}

- (void)dealloc {
	[_layer release];
	_layer = nil;
	[super dealloc];
}

@end

@implementation AboutLayer

-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
		
		
		
	}	
	return self;
}

- (void)gameOverDone {
	
	[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
	
}

- (void)dealloc {
	[_label release];
	_label = nil;
	[super dealloc];
}

@end