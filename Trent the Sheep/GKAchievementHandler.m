//
//  GKAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import <Availability.h>
#import "GKAchievementHandler.h"
#import "GKAchievementNotification.h"

static GKAchievementHandler *defaultHandler = nil;

#pragma mark -

@interface GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification;

@end

#pragma mark -

@implementation GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([GKNotificationBanner class]) {
        [GKNotificationBanner showBannerWithTitle:notification.title 
                                          message:notification.message
                                completionHandler:^{
                                    [self didHideAchievementNotification:notification];
                                }
         ];
    } else
#endif
    {
        [_topView addSubview:notification];
        [notification animateIn];
    }
}

@end

#pragma mark -

@implementation GKAchievementHandler

#pragma mark -

+ (GKAchievementHandler *)defaultHandler
{
    if (!defaultHandler) defaultHandler = [[self alloc] init];
    return defaultHandler;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _topView = [[UIApplication sharedApplication] keyWindow];
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [_queue release];
    [super dealloc];
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    [self notifyAchievement:achievement withImage:[UIImage imageNamed:@"gk-icon.png"]];
}

- (void)notifyAchievement:(GKAchievementDescription *)achievement withImage:(UIImage *)image;
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithAchievementDescription:achievement] autorelease];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([GKNotificationBanner class] == nil) {
#endif
        notification.frame = [notification startFrame];
        notification.handlerDelegate = self;
        [notification setImage:image];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    }
#endif

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message
{
    [self notifyAchievementTitle:title message:message andImage:[UIImage imageNamed:@"gk-icon.png"]];
}

- (void)notifyAchievementTitle:(NSString *)title message:(NSString *)message andImage:(UIImage *)image;
{
    GKAchievementNotification *notification = [[[GKAchievementNotification alloc] initWithTitle:title andMessage:message] autorelease];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    if ([GKNotificationBanner class] == nil) {
#endif
        notification.frame = [notification startFrame];
        notification.handlerDelegate = self;
        [notification setImage:image];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    }
#endif
    
    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

#pragma mark -
#pragma mark GKAchievementHandlerDelegate implementation

- (void)didHideAchievementNotification:(GKAchievementNotification *)notification
{
    [_queue removeObjectAtIndex:0];
    if ([_queue count])
    {
        [self displayNotification:(GKAchievementNotification *)[_queue objectAtIndex:0]];
    }
}

@end
