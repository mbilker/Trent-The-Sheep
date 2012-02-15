//
//  Perm_and_CombAppDelegate.h
//  Perm and Comb
//
//  Created by mbilker on 12/9/11.
//  Copyright mbilker 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class RootViewController;

@interface Perm_and_CombAppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate> {
	UIWindow			*window_;
	UINavigationController	*navController_;
    
    CCDirectorIOS *director_;
    
    int _score;
    int _wave;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int wave;

@end
