//
//  Projectile.m
//  Perm and Comb
//
//  Created by mbilker on 12/15/11.
//  Copyright 2011 mbilker. All rights reserved.
//

#import "Projectile.h"

@implementation Projectile
@synthesize monstersHit = _monstersHit;

- (Projectile*)initWithFile:(NSString *)file {
    if ((self = [super initWithFile:file])) {
        self.monstersHit = [NSMutableArray array];
    }
    return self;
}

- (BOOL)shouldDamageMonster:(CCSprite *)monster {
    if ([_monstersHit containsObject:monster]) {
        //NSLog(@"FALSE");
		return FALSE;
    }
    else {
        [_monstersHit addObject:monster];
		//NSLog(@"TRUE");
        return TRUE;
    }
}

- (void) dealloc
{
    self.monstersHit = nil;    
    [super dealloc];
}

@end

