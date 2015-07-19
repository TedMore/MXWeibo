//
//  NearbyViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/14/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectDoneBlock)(NSDictionary *);
@interface NearbyViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, copy) SelectDoneBlock selectBlock;

@end

