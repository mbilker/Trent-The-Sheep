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

#import "DDGameKitHelper.h"
#import "AppDelegate.h"

NSUInteger RRFactorial(NSUInteger n);
// Answers the factorial of n, or NSUIntegerMax if factorial exceeds
// NSUInteger type's upper boundary. Uses Foundation framework's NSUInteger
// type to carry factorials.

// HelloWorldLayer

@interface HelloWorldLayer : CCLayer
{
    CCSprite * _background;
    
    CCSprite *_movingSpring;
    bool _pauseScreenUp;
    CCLayer *pauseLayer;
    CCSprite *_pauseScreen;
    CCMenu *_pauseScreenMenu;
    
    int _projectilesDestroyed;
	int _maxScore;
	CCLabelTTF *_scoreLabel;
	int _oldScore;
	int _health;
    int _started;
    int _targetsDestroyed;
    int _projectileOffScreen;
    int _number;
    CCProgressTimer *_healthBar;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    
    AppController *delegate;
}

@property (nonatomic, assign) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) CCSprite *nextProjectile;
@property (nonatomic, retain) CCProgressTimer *healthBar;
@property (nonatomic, retain) AppController *delegate;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end