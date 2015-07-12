//
//  BaseViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController {
    UIView *_loadingView;
}

@property(nonatomic,assign)BOOL isBackButton;

@property(nonatomic,retain)MBProgressHUD *hud;

- (SinaWeibo *)sinaweibo;

//网络加载提示
- (void)showLoading:(BOOL)show;
//HUD控件
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
//隐藏HUD
- (void)hideHUD;
//HUD提示完成
- (void)showHUDComplete:(NSString *)title;

//状态栏上的提示
- (void)showStatusTip:(BOOL)show title:(NSString *)title;

@end
