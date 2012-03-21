//
//  Projectile.h
//  Perm and Comb
//
//  Created by mbilker on 12/15/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "cocos2d.h"

@interface Projectile : CCSprite {
    NSMutableArray *_monstersHit;
}

@property (nonatomic, retain) NSMutableArray *monstersHit;

- (Projectile*)initWithFile:(NSString *)file;
- (BOOL)shouldDamageMonster:(CCSprite *)monster;

@end
