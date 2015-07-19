//
//  CONSTS.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#ifndef MXWeibo_CONSTS_h
#define MXWeibo_CONSTS_h

#endif

//--------------------weibo OAuthu2.0------------------------
#define kAppKey @"240541115"
#define kAppSecret @"d0fcb90def010fdec7dddbe828afc2c4"
#define kAppRedirectURI @"https://api.weibo.com/oauth2/default.html"

//------------------------------url----------------------
#define URL_POIS            @"place/nearby/pois.json"       //附近位置
#define URL_HOME_TIMELINE   @"statuses/home_timeline.json"  //最新微博列表
#define URL_COMMENTS        @"comments/show.json"           //评论列表
#define URL_UPDATE          @"statuses/update.json"         //发微博（不带图）
#define URL_UPLOAD          @"statuses/upload.json"         //发微博（上传照片）
#define URL_USER_SHOW       @"users/show.json"              //用户资料
#define URL_TIMELINE        @"statuses/user_timeline.json"  //用户微博列表
#define URL_FOLLOWERS       @"friendships/followers.json"   //粉丝数
#define URL_FRIEDNS         @"friendships/friends.json"     //关注数

//颜色
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//font color keys
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel          @"kThemeListLabel"

//----用于存储的keys----
#define kThemeName @"kThemeName"
#define kBrowMode @"kBrowMode"

#define LargeBrowMode 1 //大图浏览模式
#define SmallBrowMode 2 //小图浏览模式

//----大图还是小图通知----
#define kReloadWeiboTableNotification @"kReloadWeiboTableNotification"
