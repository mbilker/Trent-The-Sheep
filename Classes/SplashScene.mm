#import "SplashScene.h"
#import "HelloWorldLayer.h"

#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OFControllerLoaderObjC.h"
#import "Delegate.h"
#import "NotificationDelegate.h"

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

- (void)initOpenFeint
{
    //[self unschedule:@selector(initOpenFeint)];
    
    // OpenFeint
    ofDelegate = [Delegate new];
    ofNotificationDelegate = [NotificationDelegate new];
    
    OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:ofDelegate
                                                                      andChallengeDelegate:nil
                                                                   andNotificationDelegate:ofNotificationDelegate];
    
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], OpenFeintSettingDashboardOrientation, "Perm and Comb", OpenFeintSettingShortDisplayName, [NSNumber numberWithBool:YES], OpenFeintSettingEnablePushNotifications, [NSNumber numberWithBool:NO], nil
                              ];
    
    [OpenFeint initializeWithProductKey:@"tP4D0ok3O3c2Ynat3EVizg"
                              andSecret:@"0cQG9feASEVdcLlIVE4tWu8owTktlxaohLaMUeQmA"
                         andDisplayName:@"Perm and Comb"
                            andSettings:settings
                           andDelegates:delegates
     ];
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
	//[self initializeOpenfeint];
	[self unschedule:@selector(aaa)];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2 scene:[HelloWorldLayer node]]];

}


-(void)dealloc
{
	//	[[TextureMgr sharedTextureMgr] removeUnusedTextures];
    [ofDelegate release];
    [ofNotificationDelegate release];
	[super dealloc];
}



@end
