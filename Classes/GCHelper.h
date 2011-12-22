//
//  GCHelper.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/19/11.
//  Copyright (c) 2011 mbilker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	UIViewController *myViewController;
	// Store unsent Game Center data
	NSMutableArray *unsentAchievements;
	
	// Store saved Game Center achievement progress
	NSMutableDictionary *achievementsDictionary;
    GKAchievementViewController *achievements;
    GKLeaderboardViewController *leaderboards;
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    NSString *currentLeaderBoard;
    NSString *personalBestScoreDescription;
    NSString *personalBestScoreString;
}

@property (retain) UIViewController *myViewController;
@property (retain) GKAchievementViewController *achievements;
@property (retain) GKLeaderboardViewController *leaderboards;
@property (retain) NSString *currentLeaderBoard;
@property (assign, readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
// Achievement methods
- (GKAchievement *)getAchievementForIdentifier:(NSString *)identifier;
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
- (void)reloadHighScoresForCategory: (NSString*) category;
- (void)scoreReported: (NSError*) error;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)showAchievements:(UIViewController *)viewController;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
- (void)showLeaderboards:(UIViewController *)viewController;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@end
