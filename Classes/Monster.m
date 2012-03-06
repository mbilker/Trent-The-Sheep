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
@synthesize animate = _animate;
@synthesize name = _name;
@synthesize amount = _amount;

@end

@implementation Pig

+ (id)monster {
    Pig *monster = nil;
    if ((monster = [[[super alloc] initWithSpriteFrameName:@"Pig_1.png"] autorelease])) {
        monster.name = @"Pig";
        monster.animate = TRUE;
        monster.amount = 4;
        monster.hp = 3;
        monster.points = 1;
        monster.minMoveDuration = 5;
        monster.maxMoveDuration = 30;
    }
    return monster;
}

@end

@implementation Ram

+ (id)monster {
    Ram *monster = nil;
    if ((monster = [[[super alloc] initWithSpriteFrameName:@"Ram_1.png"] autorelease])) {
        monster.name = @"Ram";
        monster.animate = TRUE;
        monster.amount = 4;
        monster.hp = 4;
        monster.points = 2;
        monster.minMoveDuration = 4;
        monster.maxMoveDuration = 25;
    }
    return monster;
}
@end
