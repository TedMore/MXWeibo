//
//  MessageViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"

@interface MessageViewController : BaseViewController <UITableViewEventDelegate> {
    WeiboTableView *_weiboTable;
}

@end
