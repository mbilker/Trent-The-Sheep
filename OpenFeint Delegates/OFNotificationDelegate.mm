//
//  OFNotificationDelegate.m
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OFNotificationDelegate.h"
#import "OpenFeint/OFDependencies.h"

@implementation OFNotificationDelegate

- (BOOL)isOpenFeintNotificationAllowed:(OFNotificationData*)notificationData
{
	if (notificationData.notificationCategory == kNotificationCategoryAchievement &&
		notificationData.notificationType == kNotificationTypeSuccess)
	{
		return NO;
	}
	
	return YES;
}

- (void)handleDisallowedNotification:(OFNotificationData*)notificationData
{
	NSString* message = @"We're overriding the achievement unlocked notification. Check out SampleOFNotificationDelegate.mm!";
	[[[[UIAlertView alloc] initWithTitle:@"Achievement Unlocked!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease] show];
}

- (void)notificationWillShow:(OFNotificationData*)notificationData
{
	OFLog(@"An OpenFeint notification is about to pop-up: %@", notificationData.notificationText);
}

@end
