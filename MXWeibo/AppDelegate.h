//
//  AppDelegate.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinaWeibo;
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)SinaWeibo *sinaweibo;
@property(nonatomic,retain)MainViewController *mainCtrl;

@end

