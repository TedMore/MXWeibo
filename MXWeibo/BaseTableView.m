//
//  BaseTableView.m
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initView];
    }
    return self;
}

//使用xib创建时调用
- (void)awakeFromNib
{
    [self _initView];
}

- (void)_initView
{
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor=[UIColor clearColor];
    
    
    self.dataSource=self;
    self.delegate=self;
    self.refreshHeader=YES;
    
    
    //尾部视图
    _moreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(100, 10, 20, 20);
    activityView.tag = 2013;
    [activityView stopAnimating];
    [_moreButton addSubview:activityView];
    
    self.tableFooterView = _moreButton;
    
}

- (void)setRefreshHeader:(BOOL)refreshHeader
{
    _refreshHeader=refreshHeader;
    if (_refreshHeader) {
        [self addSubview:_refreshHeaderView];
    }else{
        //有父视图的话就移除掉
        if ([_refreshHeaderView superview]) {
            [_refreshHeaderView removeFromSuperview];
        }
    }
    
}


- (void)reloadData
{
    [super reloadData];
    //停止加载更多
    [self _stopLoadMore];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    return cell;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - 下拉相关的方法

- (void)reloadTableViewDataSource{
    _reloading = YES;
    
}

//下拉弹回去
//注：这个需要声明为公开方法
- (void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)autoRefreshData
{
    [_refreshHeaderView initLoading:self];
}


- (void)_startLoadMore
{
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView startAnimating];
    
    //按钮禁用
    _moreButton.enabled=NO;
}

- (void)_stopLoadMore
{
    if (self.data.count > 0) {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
        UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
        [activityView stopAnimating];
        //按钮启用
        _moreButton.enabled = YES;
        if (!self.isMore) {
            [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _moreButton.enabled = NO;
        }
        
    }else{
        _moreButton.hidden = YES;
    }
    
    
}

#pragma mark - Action
- (void)loadMoreAction
{
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self _startLoadMore];
        [self.eventDelegate pullUp:self];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

//当滑动时，实时调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
//当手指停止拖拽时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
    if (!self.isMore) {
        return;
    }
    //偏移量
    float offset = scrollView.contentOffset.y;
    //content高度
    float contentHeight = scrollView.contentSize.height;
    
    //当offset偏移量滑动到底部时，差值是scrollView的高度
    float sub = contentHeight - offset;
    if (scrollView.height - sub > 30) {
        [self _startLoadMore];
        //使用代理
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            [self.eventDelegate pullUp:self];
        }
    }
    
    
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
    //使用代理
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading;
    
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
    
}

@end
