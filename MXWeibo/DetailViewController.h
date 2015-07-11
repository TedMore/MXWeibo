//
//  DetailViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentTableView.h"


@interface DetailViewController : BaseViewController<UITableViewEventDelegate> {
    WeiboView *_weiboView;
}



@property(nonatomic,retain)WeiboModel *weiboModel;

@property(nonatomic,retain) IBOutlet UIImageView *userImageView;
@property(nonatomic, retain) IBOutlet UILabel *nickLabel;
@property(nonatomic, retain) IBOutlet UIView *userBarView;

@property(nonatomic,retain) IBOutlet CommentTableView *tableView;

@property(nonatomic,retain)NSString *lastCommentId;
@property(nonatomic,retain)NSMutableArray *comments;

@property(nonatomic,retain)NSMutableArray *requests;

@end
