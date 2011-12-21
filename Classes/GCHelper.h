//
//  GCHelper.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/19/11.
//  Copyright (c) 2011 mbilker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject <GKAchievementViewControllerDelegate>
{
	UIViewController *myViewController;
	// Store unsent Game Center data
	NSMutableArray *unsentAchievements;
	
	// Store saved Game Center achievement progress
	NSMutableDictionary *achievementsDictionary;
    GKAchievementViewController *achievements;
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (retain) UIViewController *myViewController;
@property (retain) GKAchievementViewController *achievements;
@property (assign, readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
// Achievement methods
- (GKAchievement *)getAchievementForIdentifier:(NSString *)identifier;
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
- (void)showAchievements:(UIViewController *)viewController;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

@end
