//
//  HomeViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@class ThemeImageView;
@interface HomeViewController : BaseViewController <SinaWeiboRequestDelegate, UITableViewEventDelegate> {
    ThemeImageView *barView;
}

@property (nonatomic, retain) WeiboTableView *tableView;
@property (nonatomic, copy) NSString *topWeiboId;        //第一条微博id
@property (nonatomic, copy) NSString *lastWeiboId;       //最后一条微博id
@property (nonatomic, retain)NSMutableArray *weibos;

//自动刷新微博
- (void)autorefreshWeibo;
//初始加载微博
- (void)loadWeiboData;

@end
