//
//  FriendshipsViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/17/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendShipsTableView.h"

//定义枚举
/*
 typedef enum{
 Attention,  //关注列表
 Fans        //粉丝
 }FriendshipsType;
 */
typedef NS_ENUM(NSInteger, FriendshipsType) {
    Attention = 100,  //关注列表，如果不指定默认是0
    Fans            //粉丝，默认逐渐累加1
};

@interface FriendshipsViewController : BaseViewController <UITableViewEventDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) IBOutlet FriendShipsTableView *tableView;
//记录下一页的游标值（每次请求从新浪微博返回的一个值）
@property (nonatomic, copy) NSString *cursor;
@property (nonatomic, assign) FriendshipsType shipType;

@end
