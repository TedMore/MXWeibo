//
//  ThemeButton.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//Normal状态下的图片名称
@property (nonatomic, copy) NSString *imageName;
//高亮状态下的图片名称
@property (nonatomic, copy) NSString *highligtImageName;
//Normal状态下的背景图片名称
@property (nonatomic, copy) NSString *backgroundImageName;
//高亮状态下的背景图片名称
@property (nonatomic, copy) NSString *backgroundHighligtImageName;

//设置图片拉伸位置
@property (nonatomic, assign) int leftCapWidth; //横向离原点位置
@property (nonatomic, assign) int topCapHeight; //纵向离y位置

- (id)initWithImage:(NSString *)imageName highlighted:(NSString *)highligtImageName;
- (id)initWithBackground:(NSString *)backgroundImageName
   highlightedBackground:(NSString *)backgroundHighligtImageName;

@end
