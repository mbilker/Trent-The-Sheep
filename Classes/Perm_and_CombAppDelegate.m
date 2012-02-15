//
//  Perm_and_CombAppDelegate.m
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

#import "Perm_and_CombAppDelegate.h"
#import "GameConfig.h"
#import "SplashScene.h"
#import "HelloWorldLayer.h"

#import "DDGameKitHelper.h"

@implementation Perm_and_CombAppDelegate

@synthesize window = window_;
@synthesize navController = navController_;
@synthesize director = director_;
@synthesize score = _score;
@synthesize wave = _wave;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    // Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	director_.wantsFullScreenLayout = YES;
    
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
    
	// attach the openglView to the director
	[director_ setView:glView];
    
	// for rotation and other messages
	[director_ setDelegate:self];
    
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    //	[director setProjection:kCCDirectorProjection3D];
    
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	//if( ! [director_ enableRetinaDisplay:YES] )
	//	CCLOG(@"Retina Display Not supported");
    
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
    
	// set the Navigation Controller as the root view controller
    //	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];
    
	// make main window visible
	[window_ makeKeyAndVisible];
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// When in iPad / RetinaDisplay mode, CCFileUtils will append the "-ipad" / "-hd" to all loaded files
	// If the -ipad  / -hdfile is not found, it will load the non-suffixed version
	[CCFileUtils setiPadSuffix:@"-ipad"];			// Default on iPad is "" (empty string)
	[CCFileUtils setRetinaDisplaySuffix:@"-hd"];	// Default on RetinaDisplay is "-hd"
    
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// Run the intro Scene
	//[[CCDirector sharedDirector] runWithScene: [HelloWorldLayer scene]];
    self.wave = 0;
    self.score = 0;
    
    // Background Music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"NyanCat.caf" loop:TRUE];
    [[DDGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    [director_ pushScene:[SplashLayer scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[director_ pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[director_ resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[director_ purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[director_ startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	[[director_ view] removeFromSuperview];
	
	[navController_ release];
	
	[window_ release];
	
	[director_ end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[director_ release];
	[window_ release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
