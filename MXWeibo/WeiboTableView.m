//
//  WeiboTableView.m
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"WeiboCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    cell.weiboModel = weibo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    float height = [WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    
    height += 60;
    
    return height;
}



@end
