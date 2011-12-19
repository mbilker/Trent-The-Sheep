//
//  Perm_and_CombAppDelegate.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OFDelegate;
@class OFNotificationDelegate;
@class RootViewController;

@interface Perm_and_CombAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    OFDelegate *ofDelegate;
    OFNotificationDelegate *ofNotificationDelegate;
}

@property (nonatomic, retain) UIWindow *window;

@end
