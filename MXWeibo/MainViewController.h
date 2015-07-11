//
//  ViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface MainViewController : UITabBarController<SinaWeiboDelegate, UINavigationControllerDelegate> {
    UIView *_tabbarView;
    UIImageView *_sliderView;
    UIImageView *_badgeView;
}

- (void)showBadge:(BOOL)show;
- (void)showTarbar:(BOOL)show;

@end

