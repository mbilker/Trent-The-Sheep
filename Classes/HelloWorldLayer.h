//
//  HelloWorldLayer.h
//  Perm and Comb
//
//  Created by System Administrator on 12/9/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    int _projectilesDestroyed;
	int _maxScore;
	CCLabelTTF *_scoreLabel;
	int _score;
	int _oldScore;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
}

@property (nonatomic, assign) CCLabelTTF *scoreLabel;
@property (nonatomic, retain) CCSprite *nextProjectile;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
