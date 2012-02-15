//
//  Monster.m
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "Monster.h"

@implementation Monster

@synthesize hp = _curHp;
@synthesize points = _points;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;
@synthesize animation = _animation;

@end

@implementation WeakAndFastMonster

+ (id)monster {
	
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Target.png"] autorelease])) {
        monster.animation = nil;
        monster.hp = 1;
        monster.points = 1;
        monster.minMoveDuration = 4;
        monster.maxMoveDuration = 6;
    }
    return monster;
	
}

@end

@implementation StrongAndSlowMonster

+ (id)monster {
	
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Target2.png"] autorelease])) {
        monster.animation = nil;
        monster.hp = 3;
        monster.points = 2;
        monster.minMoveDuration = 6;
        monster.maxMoveDuration = 12;
    }
    return monster;
	
}

@end

@implementation Pig

+ (id)monster {
    CCAnimation *animation = [CCAnimation animation];
    
    [animation addFrame:[CCSprite spriteWithFile:@"farm_1.png"]];
    [animation addFrame:[CCSprite spriteWithFile:@"farm_2.png"]];
    [animation addFrame:[CCSprite spriteWithFile:@"farm_3.png"]];
    [animation addFrame:[CCSprite spriteWithFile:@"farm_4.png"]];
    
    Pig *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"farm_1.png"] autorelease])) {
        monster.scale = 0.35;
        monster.animation = animation;
        monster.hp = 3;
        monster.points = 2;
        monster.minMoveDuration = 5;
        monster.maxMoveDuration = 30;
    }
    return monster;
}

@end
