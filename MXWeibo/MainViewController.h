//
//  ViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class HomeViewController;
@interface MainViewController : UITabBarController <SinaWeiboDelegate, UINavigationControllerDelegate> {
    UIView *_tabbarView;            //Tabbar视图
    UIImageView *_sliderView;       //滑动线视图
    UIImageView *_badgeView;        //未读数微博视图
    HomeViewController *_homeCtrl;  //首页控制器,控制首页刷新
}

/**
 *  Whether to show unread count
 *
 *  @param show YES/NO
 */
- (void)showBadge:(BOOL)show;

/**
 *  Whether to show Tabbar View
 *
 *  @param show YES/NO
 */
- (void)showTarbar:(BOOL)show;

@end

