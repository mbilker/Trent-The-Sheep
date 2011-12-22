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

@end

@implementation WeakAndFastMonster

+ (id)monster {
	
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"Target.png"] autorelease])) {
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
        monster.hp = 3;
        monster.points = 2;
        monster.minMoveDuration = 6;
        monster.maxMoveDuration = 12;
    }
    return monster;
	
}

@end
