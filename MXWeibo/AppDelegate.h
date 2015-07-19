//
//  AppDelegate.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"

@class MainViewController;
@class SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) SinaWeibo *sinaweibo;
@property (nonatomic, retain) MainViewController *mainCtrl;
@property (nonatomic, retain) DDMenuController *ddMenuCtrl;

@end

