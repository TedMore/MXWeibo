//
//  WeiboAnnotationView.h
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView

@property (nonatomic, retain) UIImageView *userImage; //用户头像
@property (nonatomic, retain) UIImageView *weiboImage; //微博图片视图
@property (nonatomic, retain) UILabel *textLabel; //微博内容

@end
