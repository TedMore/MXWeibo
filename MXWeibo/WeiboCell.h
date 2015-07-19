//
//  WeiboCell.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "InterfaceImageView.h"


@class WeiboModel;
@class WeiboView;

@interface WeiboCell : UITableViewCell {
    InterfaceImageView     *_userImage;    //用户头像视图
    UILabel         *_nickLabel;    //昵称
    UILabel         *_repostCountLabel; //转发数
    UILabel         *_commentLabel;     //回复数
    UILabel         *_sourceLabel;      //发布来源
    UILabel         *_createLabel;      //发布时间
}

@property (nonatomic, retain) WeiboModel *weiboModel;   //微博数据模型对象
@property (nonatomic, retain) WeiboView *weiboView;     //微博视图

@end
