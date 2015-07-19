//
//  UIView+Additions.m
//  MXWeibo
//
//  Created by TedChen on 7/12/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (UIViewController *)viewController {
    //下一个响应者
    UIResponder *next=self.nextResponder;
    //循环查找viewController
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next=next.nextResponder;
    } while (next!=nil);
    return nil;
}

@end

