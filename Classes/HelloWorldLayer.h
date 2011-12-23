//
//  HelloWorldLayer.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Perm_and_CombAppDelegate.h"
#import "RootViewController.h"
#import "GCHelper.h"

NSUInteger RRFactorial(NSUInteger n);
// Answers the factorial of n, or NSUIntegerMax if factorial exceeds
// NSUInteger type's upper boundary. Uses Foundation framework's NSUInteger
// type to carry factorials.

// HelloWorldLayer
@class GCHelper;
@interface HelloWorldLayer : CCLayerColor <GameCenterManagerDelegate>
{
    int _projectilesDestroyed;
	int _maxScore;
	CCLabelTTF *_scoreLabel;
	int64_t _score;
	int64_t _oldScore;
	int _health;
	int _wave;
    int _started;
    int _targetsDestroyed;
    int _projectileOffScreen;
    CCProgressTimer *_healthBar;
    CCLabelTTF *_status;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    
    Perm_and_CombAppDelegate *delegate;
    GCHelper *gameCenterManager;
}

@property (nonatomic, retain) GCHelper *gameCenterManager;
@property (nonatomic, assign) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) CCSprite *nextProjectile;
@property (nonatomic, retain) CCProgressTimer *healthBar;
@property (nonatomic, assign) int64_t _score;
@property (nonatomic, retain) CCLabelTTF *status;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
