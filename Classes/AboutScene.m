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
@synthesize label = _label;


-(id) init
{
	if( (self=[super initWithColor:ccc4(223,155,48,245)] )) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.label = [CCLabelBMFont labelWithString:@"About\n\nTutorial By Ray Wenderlich\nArt by Vicki Wenderlich\nProject for Mrs. Murray's Math class" fntFile:@"Arial.fnt"];
        _label.scale = 0.1;
        _label.position = ccp(winSize.width/2,(winSize.height/2 + 55));
        [self addChild:_label];
        
        [_label runAction:[CCSequence actions:
                           [CCScaleTo actionWithDuration:0.5 scale:0.75],[CCDelayTime actionWithDuration:5],
                           [CCCallFunc actionWithTarget:self selector:@selector(aboutDone)],
                           nil]];
	}	
	return self;
}

- (void)aboutDone {
	
	[[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
	
}

- (void)dealloc {
    [_label release];
    _label = nil;
	[super dealloc];
}

@end