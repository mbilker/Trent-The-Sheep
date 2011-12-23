//
//  GCHelper.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/19/11.
//  Copyright (c) 2011 mbilker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class GKLeaderboard, GKAchievement, GKPlayer;

@protocol GameCenterManagerDelegate <NSObject>
@optional
-(void)scoreReported: (NSError*) error;
-(void)reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
-(void)achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
-(void)achievementResetResult: (NSError*) error;
@end

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
    
    id <GameCenterManagerDelegate, NSObject> delegate;
}

@property (nonatomic, assign) NSString *personalBestScoreDescription;
@property (nonatomic, assign) NSString *personalBestScoreString;

@property (retain) UIViewController *myViewController;
@property (retain) GKAchievementViewController *achievements;
@property (retain) GKLeaderboardViewController *leaderboards;
@property (retain) NSString *currentLeaderBoard;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, assign) id <GameCenterManagerDelegate> delegate;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
// Achievement methods
- (GKAchievement *)getAchievementForIdentifier:(NSString *)identifier;
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
- (void)resetAchievements;
- (void)reloadHighScoresForCategory: (NSString*) category;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)showAchievements:(UIViewController *)viewController;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
- (void)showLeaderboards:(UIViewController *)viewController;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@end
