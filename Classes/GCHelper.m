//
//  GCHelper.m
//  Perm and Comb
//
//  Created by Matt Bilker on 12/19/11.
//  Copyright (c) 2011 mbilker. All rights reserved.
//

#import "GCHelper.h"
#import "cocos2d.h"

#import "Achievements.h"

@implementation GCHelper

@synthesize gameCenterAvailable;
@synthesize myViewController;
@synthesize achievements;
@synthesize leaderboards;
@synthesize currentLeaderBoard;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer 
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self 
                   selector:@selector(authenticationChanged) 
                       name:GKPlayerAuthenticationDidChangeNotificationName 
                     object:nil];
			// Load player achievements
			[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *listAchievements, NSError *error) {
				if (error != nil)
				{
					// handle errors
				}
				if (listAchievements != nil)
				{
					// process array of achievements
					for (GKAchievement* achievement in listAchievements)
						[achievementsDictionary setObject:achievement forKey:achievement.identifier];
				}
			}];
        }
    }
    return self;
}

- (void)authenticationChanged {    
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;           
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
	UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
	[alert show];
	
}

#pragma mark User functions

- (void)authenticateLocalUser { 
    
    if (!gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];        
    } else {
        NSLog(@"Already authenticated!");
    }
}

#pragma mark -
#pragma mark Achievement methods

/**
 * Get an achievement object in the locally stored dictionary
 */
- (GKAchievement *)getAchievementForIdentifier:(NSString *)identifier
{
	if (gameCenterAvailable)
	{
		GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
		if (achievement == nil)
		{
			achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
			[achievementsDictionary setObject:achievement forKey:achievement.identifier];
		}
		return [[achievement retain] autorelease];
	}
	return nil;
}


/**
 * Send a completion % for a specific achievement to Game Center - increments an existing achievement object
 */
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent
{
	if (gameCenterAvailable)
	{
		// Instantiate GKAchievement object for an achievement (set up in iTunes Connect)
		GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
		if (achievement)
		{
			achievement.percentComplete = percent;
			[achievement reportAchievementWithCompletionHandler:^(NSError *error)
			 {
				 if (error != nil)
				 {
					 // Retain the achievement object and try again later
					 [unsentAchievements addObject:achievement];
					 
					 NSLog(@"Error sending achievement!");
				 }
			 }];
		}
	}
}

#pragma mark View Controllers

/**
 * Create a GKAchievementViewController and display it on top of cocos2d's OpenGL view
 */
- (void)showAchievements:(UIViewController *)viewController
{
	if (gameCenterAvailable)
	{
		self.achievements = [[GKAchievementViewController alloc] init];
		if (achievements != nil)
		{
			achievements.achievementDelegate = self;
            self.myViewController = viewController;
            [myViewController dismissModalViewControllerAnimated:NO];
            
            [[CCDirector sharedDirector] pause];
            [[CCDirector sharedDirector] stopAnimation];
			
			[myViewController presentModalViewController:achievements animated:YES];
		}
		[achievements release];
	}
}

/**
 * Dismiss an active GKAchievementViewController
 */
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[myViewController dismissModalViewControllerAnimated:YES];
    // BUG: If released 3 times, a EXC_BAD_ACCESS is made.
    // SOLUTION: Don't release, game still functions fine.
	//[myViewController release];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}

- (void)showLeaderboards:(UIViewController *)viewController
{
    if (gameCenterAvailable)
	{
        self.leaderboards = [[GKLeaderboardViewController alloc] init];
        if (leaderboards != nil)
        {
            self.currentLeaderBoard= kEasyLeaderboardID;
            leaderboards.category = self.currentLeaderBoard;
            leaderboards.timeScope = GKLeaderboardTimeScopeToday;
            leaderboards.leaderboardDelegate = self;
            self.myViewController = viewController;
            [myViewController dismissModalViewControllerAnimated:NO];
            
            [[CCDirector sharedDirector] pause];
            [[CCDirector sharedDirector] stopAnimation];
            
            [myViewController presentModalViewController:leaderboards animated:YES];
        }
        [leaderboards release];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [myViewController dismissModalViewControllerAnimated:YES];
    // BUG: If released 3 times, a EXC_BAD_ACCESS is made.
    // SOLUTION: Don't release, game still functions fine.
	//[myViewController release];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}


@end
