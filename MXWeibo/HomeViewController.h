//
//  HomeViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SinaWeiboRequestDelegate>


@property(nonatomic,retain)NSArray *data;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
