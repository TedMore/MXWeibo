//
//  WeiboAnnotationView.m
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //边框
    _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImage.layer.borderWidth = 1;
    
    //微博图片
    _weiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //保持比例显示（可能图片不能显示全）
    _weiboImage.contentMode = UIViewContentModeScaleAspectFill;
    _weiboImage.backgroundColor = [UIColor blackColor];
    
    //微博文字
    _textLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont systemFontOfSize:12.0f];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.numberOfLines = 3;
    [self addSubview:self.weiboImage];
    [self addSubview:self.textLabel];
    [self addSubview:self.userImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //获得annotation
    //注：MKAnnotationView类就有这个property
    WeiboAnnotation *weiboAnnotation = self.annotation;
    WeiboModel *weibo = nil;
    //做一步严谨的判断
    if ([weiboAnnotation isKindOfClass:[WeiboAnnotation class]]) {
        weibo = weiboAnnotation.weiboModel;
    }
    //微博是否有图片
    NSString *thumbnailImage = weibo.thumbnailImage;
    if (thumbnailImage.length > 0) {
        //注：MKAnnotationView类就有image这个property,可用于设置背景图片
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        
        //微博图片
        self.weiboImage.frame = CGRectMake(15, 15, 90, 85);
        [self.weiboImage setImageWithURL:[NSURL URLWithString:weibo.thumbnailImage]];;
        
        //头像
        self.userImage.frame = CGRectMake(70, 70, 30, 30);
        NSString *userURL = weibo.user.profile_image_url;
        [self.userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        //考虑MKAnnotationView复用的情况
        self.weiboImage.hidden = NO;
        self.textLabel.hidden = YES;
        
    }
    else {
        //背景图片
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        
        //头像
        self.userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *userURL = weibo.user.profile_image_url;
        [self.userImage setImageWithURL:[NSURL URLWithString:userURL]];
        
        //微博内容
        self.textLabel.frame = CGRectMake(self.userImage.right+5, self.userImage.top, 110, 45);
        self.textLabel.text = weibo.text;
        
        //考虑MKAnnotationView复用的情况
        self.weiboImage.hidden = YES;
        self.textLabel.hidden = NO;
    }
}

@end
