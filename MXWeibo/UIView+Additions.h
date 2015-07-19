//
//  UIView+Additions.h
//  MXWeibo
//
//  Created by TedChen on 7/12/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

//超找当前view的上层第一个viewController
- (UIViewController *)viewController;

@end