//
//  UserInfoView.h
//  MXWeibo
//
//  Created by TedChen on 7/12/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "RectButton.h"

@interface UserInfoView : UIView

@property (nonatomic, retain) UserModel            *user;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;       //头像
@property (nonatomic, retain) IBOutlet UILabel     *nickLabel;       //昵称
@property (nonatomic, retain) IBOutlet UILabel     *addressLabel;    //地址
@property (nonatomic, retain) IBOutlet UILabel     *infoLabel;       //简介
@property (nonatomic, retain) IBOutlet RectButton  *attButton;       //关注按钮
@property (nonatomic, retain) IBOutlet RectButton  *fansButton;      //粉丝按钮
@property (nonatomic, retain) IBOutlet RectButton  *profileButton;   //资料按钮
@property (nonatomic, retain) IBOutlet RectButton  *moreButton;      //更多按钮
@property (nonatomic, retain) IBOutlet UILabel     *contentLabel;    //微博总数量

- (IBAction)attAction:(id)sender;
- (IBAction)fansAction:(id)sender;

@end
