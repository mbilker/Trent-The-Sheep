//
//  SplashScene.h
//  PuffPuffV
//
//  Created by Pablo Ruiz on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "OpenFeint/OpenFeint.h"
#import "OpenFeint/OpenFeintSettings.h"
#import "Perm_and_CombAppDelegate.h"

@class Delegate;
@class NotificationDelegate;

@interface SplashLayer : CCLayer
{
    Delegate *ofDelegate;
    NotificationDelegate *ofNotificationDelegate;
}

@end
