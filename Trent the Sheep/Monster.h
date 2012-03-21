//
//  Monster.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "cocos2d.h"

@interface Monster : CCSprite {
    NSString *_name;
    BOOL _animate;
    int _amount;
    int _curHp;
    int _points;
    int _minMoveDuration;
    int _maxMoveDuration;
}

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) BOOL animate;
@property (nonatomic, assign) int amount;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

@end

@interface Pig : Monster {
}
+(id)monster;
@end

@interface Ram : Monster {
}
+(id)monster;
@end
