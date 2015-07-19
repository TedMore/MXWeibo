//
//  FriendshipsViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/17/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "MXDataService.h"
#import "UserModel.h"

@interface FriendshipsViewController ()

@end

@implementation FriendshipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数组
    self.data = [NSMutableArray array];
    self.tableView.eventDelegate = self;
//    [super showLoading:YES];
    if (self.shipType == Fans) {
        self.title = @"粉丝数";
        [self loadFriendshipData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention) {
        self.title = @"关注数";
        [self loadFriendshipData:URL_FRIEDNS];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFriendshipData:(NSString *)url {
    if (self.userId.length == 0) {
        NSLog(@"用户id为空");
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    //如果有下一页的游标，则传递。
    if (self.cursor.length > 0) {
        [params setObject:self.cursor forKey:@"cursor"];
    }
    [MXDataService requestWithURL:url
                           params:params
                       httpMethod:@"GET" completeBlock:^(id result) {
                           [self loadDataFinish:result];
                       }];
    
}

- (void)loadDataFinish:(NSDictionary *)result {
//    [super showLoading:NO];
    //用户数据
    NSArray *usersArray = [result objectForKey:@"users"];
    /*组合后的结构：
     *[
     * [用户1,用户2，用户3],
     * [用户1,用户2，用户3],
     * ......
     *]
     */
    NSMutableArray *array2D = nil;
    for (int i=0; i<usersArray.count; i++) {
        array2D = [self.data lastObject];
        //每次判断最后一个数组是否填满数据
        if (array2D.count == 3 || array2D == nil) {
            array2D = [NSMutableArray arrayWithCapacity:3];
            [self.data addObject:array2D];
        }
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
        [userModel release];
    }
    //刷新UI
    //此处虽然请求的是50，但是新浪接口经常返回的不足50
    if (usersArray.count < 47) {
        self.tableView.isMore = NO;
    }
    else {
        self.tableView.isMore = YES;
    }
    self.tableView.data = self.data;
    [self.tableView reloadData];
    
    //收回下拉
    if (self.cursor == nil) {
        [self.tableView doneLoadingTableViewData];
    }
    //记录游标值
    self.cursor = [[result objectForKey:@"next_cursor"] stringValue];
}


- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark -UITableView EventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView {
    //此时下拉的功能是：重新显示第一页，且只显示第一页。
    self.cursor = nil;
    [self.data removeAllObjects];
    if (self.shipType == Fans) {
        [self loadFriendshipData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention) {
        [self loadFriendshipData:URL_FRIEDNS];
    }
}

//上拉
- (void)pullUp:(BaseTableView *)tableView {
    [self.data removeAllObjects];
    if (self.shipType == Fans) {
        [self loadFriendshipData:URL_FOLLOWERS];
    }
    else if (self.shipType == Attention) {
        [self loadFriendshipData:URL_FRIEDNS];
    }
}

@end
