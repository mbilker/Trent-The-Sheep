//
//  OFDelegate.m
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Delegate.h"
#import "OpenFeint/OpenFeint+UserOptions.h"
#import "cocos2d.h"

@implementation Delegate

- (void)dashboardWillAppear
{
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
}

- (void)dashboardDidAppear
{
}

- (void)dashboardWillDisappear
{
}

- (void)dashboardDidDisappear
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}

- (void)offlineUserLoggedIn:(NSString*)userId
{
	NSLog(@"User logged in, but OFFLINE. UserId: %@", userId);
}

- (void)userLoggedIn:(NSString*)userId
{
	NSLog(@"User logged in. UserId: %@", userId);
}

- (BOOL)showCustomOpenFeintApprovalScreen
{
	return NO;
}

@end