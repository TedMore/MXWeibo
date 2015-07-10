//
//  BaseViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@interface BaseViewController : UIViewController

@property(nonatomic,assign)BOOL isBackButton;

- (SinaWeibo *)sinaweibo;

@end
