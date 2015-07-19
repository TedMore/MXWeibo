//
//  ThemeImageView.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic, copy) NSString *imageName; //图片名称
@property (nonatomic, assign) int leftCapWidth;
@property (nonatomic, assign) int topCapHeight;

- (id)initWithImageName:(NSString *)imageName;

@end
