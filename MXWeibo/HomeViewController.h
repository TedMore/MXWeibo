//
//  HomeViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface HomeViewController : BaseViewController<SinaWeiboRequestDelegate, UITableViewEventDelegate> {
    
}


@property (retain, nonatomic) WeiboTableView *tableView;
//第一条微博id
@property(nonatomic,copy)NSString *topWeiboId;
//最后一条微博id
@property(nonatomic,copy)NSString *lastWeiboId;

@property(nonatomic,retain)NSMutableArray *weibos;

//显示微博数量的横条
@property(nonatomic,retain)UIImageView *barView;

//自动刷新微博
- (void)autorefreshWeibo;
//初始加载微博
- (void)loadWeiboData;
@end
