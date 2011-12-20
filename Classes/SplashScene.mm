#import "SplashScene.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"

@implementation SplashLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	[[CCDirector sharedDirector] setDisplayFPS:NO];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [SplashLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		CCSprite * bg2 = [CCSprite spriteWithFile:@"Default.png"];
        bg2.position = ccp(240, 160);
        [self addChild:bg2];
        //[self initOpenFeint];
		
		[self schedule:@selector(aaa) interval:1];
    }
    return self;
}

-(void)aaa
{
	[self unschedule:@selector(aaa)];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[HelloWorldLayer node]]];

}


-(void)dealloc
{
	//	[[TextureMgr sharedTextureMgr] removeUnusedTextures];
	[super dealloc];
}



@end
