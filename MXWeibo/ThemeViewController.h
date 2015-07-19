//
//  ThemeViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *themes;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
