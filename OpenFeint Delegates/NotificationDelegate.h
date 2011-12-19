//
//  OFNotificationDelegate.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "OpenFeint/OFNotificationDelegate.h"

@interface NotificationDelegate : NSObject< OFNotificationDelegate >

- (BOOL)isOpenFeintNotificationAllowed:(OFNotificationData*)notificationData;
- (void)handleDisallowedNotification:(OFNotificationData*)notificationData;
- (void)notificationWillShow:(OFNotificationData*)notificationData;

@end
