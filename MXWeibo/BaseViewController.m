//
//  BaseViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UIFactory.h"
#include "CONSTS.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && self.isBackButton) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.frame = CGRectMake(0, 0, 24, 24);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//override
//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    //    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //    titleLabel.textColor = [UIColor blackColor];
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

- (SinaWeibo *)sinaweibo {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegate.sinaweibo;
    return sinaweibo;
}

#pragma mark - loading
- (void)showLoading:(BOOL)show
{
    if (_loadingView == nil) {
        _loadingView = [[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 20)] autorelease];
        
        //风火轮视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        
        //label
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载......";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        
        loadLabel.left = (ScreenWidth-loadLabel.width)/2;
        activityView.right = loadLabel.left-5;
        
        [_loadingView addSubview:loadLabel];
        [_loadingView addSubview:activityView];
        [activityView release];
    }
    if (show) {
        //NSLog(@"----%@",[self.loadingView superview]);
        if (![_loadingView superview]) {
            [self.view addSubview:_loadingView];
        }
    }else{
        [_loadingView removeFromSuperview];
    }
}


- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (isDim) {
        //黑色背景遮罩
        self.hud.dimBackground = YES;
    }
    if (title.length > 0) {
        self.hud.labelText=title;
    }
}

- (void)hideHUD{
    [self.hud hide:YES];
}

- (void)showHUDComplete:(NSString *)title
{
    self.hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease] ;
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    //2秒后隐藏
    [self.hud hide:YES afterDelay:2];
}

- (void)cancelAction
{
//    [self dismissModalViewControllerAnimated:YES];
}

/*
- (void)showStatusTip:(BOOL)show title:(NSString *)title
{
    if (self.tipWindow==nil) {
        self.tipWindow=[[[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)] autorelease];
        //设置同状态栏一样的级别
        self.tipWindow.windowLevel=UIWindowLevelStatusBar;
        self.tipWindow.backgroundColor=[UIColor blackColor];
        
        UILabel *tipLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)] autorelease];
        tipLabel.textAlignment=UITextAlignmentCenter;
        tipLabel.font=[UIFont systemFontOfSize:13.0f];
        tipLabel.textColor=[UIColor whiteColor];
        tipLabel.backgroundColor=[UIColor clearColor];
        tipLabel.tag=2013;
        [self.tipWindow addSubview:tipLabel];
        
        UIImageView *progress=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]] autorelease];
        progress.frame=CGRectMake(0, 20-6, 100, 6);
        progress.tag=2012;
        [self.tipWindow addSubview:progress];
        
    }
    
    UILabel *tipLabel=(UILabel *)[self.tipWindow viewWithTag:2013];
    UIImageView *progress=(UIImageView *)[self.tipWindow viewWithTag:2012];
    if (show) {
        tipLabel.text=title;
        self.tipWindow.hidden=NO;
        //进度条动画效果
        progress.left=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:2];
        //不断循环
        [UIView setAnimationRepeatCount:1000];
        //匀速运动
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        progress.left=ScreenWidth;
        [UIView commitAnimations];
        
    }else{
        //进度条隐藏
        progress.hidden=YES;
        tipLabel.text=title;
        //延迟消失
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1.5];
    }
    
}
*/

@end

