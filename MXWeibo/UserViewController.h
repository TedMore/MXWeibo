//
//  UserViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/12/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#include "WeiboTableView.h"

@class UserInfoView;
@interface UserViewController : BaseViewController <UITableViewEventDelegate> {
    NSMutableArray *_requests;

}
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UserInfoView *userInfo;
@property (nonatomic, retain) IBOutlet WeiboTableView *tableView;
@property (nonatomic, copy) NSString *userId;

//是否是显示当前用户的资料
@property (nonatomic, assign) BOOL showLoginUser;

@end
