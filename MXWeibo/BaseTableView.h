//
//  BaseTableView.h
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol UITableViewEventDelegate <NSObject>

@optional
//下拉
- (void)pullDown:(BaseTableView *)tableView;
//上拉
- (void)pullUp:(BaseTableView *)tableView;
//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface BaseTableView : UITableView <EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
}

@property (nonatomic, assign) BOOL refreshHeader;                           //是否需要下拉效果
@property (nonatomic, retain) NSArray *data;                                //为talbeview提供数据
@property (nonatomic, assign) id<UITableViewEventDelegate> eventDelegate;   //代理
@property (nonatomic, assign) BOOL isMore;                                  //是否还有更多

//下拉弹回去
- (void)doneLoadingTableViewData;
//自动下拉刷新
- (void)autoRefreshData;

@end
