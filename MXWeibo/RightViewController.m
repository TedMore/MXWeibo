//
//  RightViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton *)sender {
    if (sender.tag == 100) {
        SendViewController *sendCtrl = [[SendViewController alloc] init];
        BaseNavigationController *sendNav = [[BaseNavigationController alloc] initWithRootViewController:sendCtrl];
        [self.appDelegate.ddMenuCtrl presentViewController:sendNav animated:YES completion:nil];
        [sendCtrl release];
        [sendNav release];
    }
}

@end
