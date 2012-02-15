//
//  Monster.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "cocos2d.h"

@interface Monster : CCSprite {
    CCAnimation *_animation;
    int _curHp;
    int _points;
    int _minMoveDuration;
    int _maxMoveDuration;
}

@property (nonatomic, assign) CCAnimation *animation;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

@end

@interface WeakAndFastMonster : Monster {
}
+(id)monster;
@end

@interface StrongAndSlowMonster : Monster {
}
+(id)monster;
@end

@interface Pig : Monster {
}
+(id)monster;
@end

