//
//  Perm_and_CombAppDelegate.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Delegate;
@class NotificationDelegate;
@class RootViewController;

@interface Perm_and_CombAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    Delegate *ofDelegate;
    NotificationDelegate *ofNotificationDelegate;
}

@property (nonatomic, retain) UIWindow *window;

@end
