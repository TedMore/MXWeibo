//
//  CustomCatagory.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "CustomCatagory.h"
#import "ThemeManager.h"

//5.0以下系统自定义UINavigationBar背景
@implementation UINavigationBar(setbackgroud)

- (void)drawRect:(CGRect)rect {
    //UIImage *image = [UIImage imageNamed:@"navigationbar_background.png"];
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"navigationbar_background.png"];
    [image drawInRect:rect];
}

@end
