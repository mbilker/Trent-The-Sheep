//
//  OFDelegate.h
//  Perm and Comb
//
//  Created by Matt Bilker on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#pragma once

#import "OpenFeint/OpenFeintDelegate.h"

@interface OFDelegate : NSObject< OpenFeintDelegate >

- (void)dashboardWillAppear;
- (void)dashboardDidAppear;
- (void)dashboardWillDisappear;
- (void)dashboardDidDisappear;
- (void)userLoggedIn:(NSString*)userId;
- (BOOL)showCustomOpenFeintApprovalScreen;

@end
