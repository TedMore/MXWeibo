//
//  MessageViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "MessageViewController.h"
#import "UIFactory.h"
#import "MXDataService.h"
#import "WeiboModel.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self loadAtWeiboData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    //导航按钮
    NSArray *imageNames = [NSArray arrayWithObjects:
                           @"navigationbar_mentions.png",
                           @"navigationbar_comments.png",
                           @"navigationbar_messages.png",
                           @"navigationbar_notice.png",
                           nil];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.navigationItem.titleView = titleView;
    for (int i=0; i<imageNames.count; i++) {
        NSString *imageName = imageNames[i];
        UIButton *button = [UIFactory createButton:imageName
                                     highlighted:imageName];
        //自带的高亮效果
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50*i+20, 10, 22, 22);
        [button addTarget:self
                   action:@selector(messageAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [titleView addSubview:button];
    }
    
    //UITableView
    _weiboTable = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44-49)];
    _weiboTable.eventDelegate = self;
    _weiboTable.hidden = YES;
    [self.view addSubview:_weiboTable];
}

- (void)messageAction:(UIButton *)button {
    
    int tag = (int)button.tag ;
    if (tag==100) {
        //@我的微博
    }
    else if (tag==101){
        //评论
    }
    else if (tag==102){
        //私信
    }
    else if (tag==103){
        //系统通知
    }
}

//加载@我的微博
- (void)loadAtWeiboData {
    [super showLoading:YES];
    [MXDataService requestWithURL:@"statuses/mentions.json"
                           params:nil
                       httpMethod:@"GET" completeBlock:^(id result) {
                           [self loadAtWeiboDataFinish:result];
                       }];
}

//加载完成
- (void)loadAtWeiboDataFinish:(NSDictionary *)result {
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
    }
    //刷新UI
    [super showLoading:NO];
    _weiboTable.hidden = NO;
    _weiboTable.data = weibos;
    [_weiboTable reloadData];
}

#pragma mark - BaseTableView Delegate
//下拉
- (void)pullDown:(BaseTableView *)tableView {
}
//上拉
- (void)pullUp:(BaseTableView *)tableView {
    
}
//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
