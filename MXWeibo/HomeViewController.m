//
//  HomeViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "UIFactory.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
    //绑定按钮
    UIBarButtonItem *bindItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定账号" style:UIBarButtonItemStylePlain target:self action:@selector(bindAction:)];
    self.navigationItem.rightBarButtonItem = [bindItem autorelease];
    
    //注销按钮
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-44) style:UITableViewStylePlain];
    
    _tableView.eventDelegate = self;
    
    [self.view addSubview:_tableView];
    
    //判断是否认证
    if (self.sinaweibo.isAuthValid) {
        //加载微博列表数据
        [self loadWeiboData];
    }
}

#pragma mark - UI
//显示新微博的数量
- (void)showNewWeiboCount:(int)count
{
    if (barView == nil) {
        barView = [[UIFactory createImageView:@"timeline_new_status_background.png"] retain];
        //拉伸图片
        UIImage *image = [barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        barView.image = image;
        barView.leftCapWidth = 5;
        barView.topCapHeight = 5;
        barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);
        [self.view addSubview:barView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 2013;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [barView addSubview:label];
        [label release];
    }
    
    if (count > 0) {
        UILabel *label = (UILabel *)[barView viewWithTag:2013];
        label.text = [NSString stringWithFormat:@"%d条新微博",count];
        [label sizeToFit];
        label.origin = CGPointMake((barView.width-label.width)/2, (barView.height-label.height)/2);
        //动画效果
        [UIView animateWithDuration:0.6 animations:^{
            barView.top = 5;
        } completion:^(BOOL finished){
            if (finished) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                barView.top = -40;
                [UIView commitAnimations];
            }
        }];
        
        //播放提示声音
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url=[NSURL fileURLWithPath:filePath];
        
        //声明系统声音id
        SystemSoundID soundId;
        //注册系统声音
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        //播放声音
        AudioServicesPlaySystemSound(soundId);
    }
    
    //清除TabBar中的未读数量
    //或者通过AppDelegate获得MainViewController
    MainViewController *mainCtrl=(MainViewController *)self.tabBarController;
    [mainCtrl showBadge:NO];
    
    
}


#pragma mark - BaseTablViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    
    [self pullDownData];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
}

//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeiboModel *weiboModel = [tableView.data objectAtIndex:indexPath.row];
    DetailViewController *detailCtrl = [[DetailViewController alloc] init];
    detailCtrl.weiboModel = weiboModel;
    [self.navigationController pushViewController:detailCtrl animated:YES];
    [detailCtrl release];
}

#pragma mark - Load Data
//默认加载微博
- (void)loadWeiboData
{
    
    //显示正在加载
    //[super showLoading:YES];
//    [super showHUD:@"正在加载..." isDim:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
}

//下拉请求数据
- (void)pullDownData
{
    if (self.topWeiboId.length == 0) {
        NSLog(@"微博id为空");
        //弹回
        //直接调用doneLoadingTableViewData不起作用，需要延迟1秒以上
        //[self.tableView doneLoadingTableViewData];
        [self.tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1];
        return;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.topWeiboId,@"since_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullDownDataFinish:result];
                             }];
}

//上拉请求数据
- (void)pullUpData
{
    if (self.lastWeiboId.length==0) {
        NSLog(@"微博id为空");
        return;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",self.lastWeiboId,@"max_id",nil];
    [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                             block:^(id result){
                                 [self pullUpDataFinish:result];
                             }];
    
}

//下拉加载完成
- (void)pullDownDataFinish:(id)result
{
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[WeiboModel alloc] initWithDataDic:statuesDic] ;
        [array addObject:weibo];
    }
    
    //更新最大id
    if (array.count > 0) {
        
        WeiboModel *weibo =[array objectAtIndex:0];
        self.topWeiboId = [weibo.weiboId stringValue];
    }
    
    //追加数组
    [array addObjectsFromArray:self.weibos];
    self.weibos = array;
    self.tableView.data = array;
    
    //刷新
    [self.tableView reloadData];
    
    //弹回
    [self.tableView doneLoadingTableViewData];
    
    //显示刷新了多少条微博
    int count = (int)[statuses count];
    [self showNewWeiboCount:count];
}

//上拉加载完成
- (void)pullUpDataFinish:(id)result
{
    NSArray *statuses=[result objectForKey:@"statuses"];
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *statuesDic in statuses) {
        WeiboModel *weibo=[[[WeiboModel alloc] initWithDataDic:statuesDic] autorelease];
        [array addObject:weibo];
    }
    
    //更新最后一个id
    if (array.count>0) {
        //移除第一个重复的（这是新浪微博接口的问题）
        [array removeObjectAtIndex:0];
        WeiboModel *weibo=[array lastObject];
        self.lastWeiboId=[weibo.weiboId stringValue];
    }
    
    if (statuses.count>=20) {
        self.tableView.isMore=YES;
    }else{
        self.tableView.isMore=NO;
    }
    
    //追加数组
    [self.weibos addObjectsFromArray:array];
    self.tableView.data=self.weibos;
    
    //刷新
    [self.tableView reloadData];
    
}

- (void)autorefreshWeibo
{
    //使UI显示下拉
    [self.tableView autoRefreshData];
    //取数据
    [self pullDownData];
}



#pragma mark - SinaWeiboRequest delegate
//网络加载失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"网络加载失败:%@",error);
}

//网络加载完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *statuesDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data = weibos;
    self.weibos = weibos;
    
    if (weibos.count > 0) {
        WeiboModel *topWeibo = [weibos objectAtIndex:0];
        self.topWeiboId = [topWeibo.weiboId stringValue];
    }
    
    //刷新tableView
    [self.tableView reloadData];
}


#pragma mark - actions
- (void)bindAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logIn];
}

- (void)logoutAction:(UIBarButtonItem *)buttonItem {
    [self.sinaweibo logOut];
}

#pragma mark - Memery Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    
}


@end
