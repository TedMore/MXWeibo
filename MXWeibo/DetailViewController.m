//
//  DetailViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentModel.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"微博详情";
    
    [self _initView];
    
    [self loadData];
    
}


- (void)_initView
{
    //创建tableView头视图
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //加载用户头像
    NSString *userImageurl = _weiboModel.user.profile_image_url;
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageurl]];
    
    //昵称
    self.nickLabel.text = _weiboModel.user.screen_name;
    
    [tableHeaderView addSubview:self.userBarView];
    
//    //小图标
//    UIImageView *iconImage=[[[UIImageView alloc] initWithFrame:CGRectMake(userBarView.width-20, (64-13)/2, 8, 13)] autorelease];
//    iconImage.image=[UIImage imageNamed:@"icon_detail.png"];
//    [userBarView addSubview:iconImage];
//    
    
    //----创建微博视图----
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isRepost:NO isDetail:YES];
    _weiboView=[[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = self.weiboModel;
    [tableHeaderView addSubview:_weiboView];
    
    
//    //间隔横线
//    UIImageView *separatorImage=[[UIImageView alloc] initWithFrame:CGRectMake(5, _weiboView.bottom+10, ScreenWidth-5, 1)];
//    separatorImage.image=[UIImage imageNamed:@"userinfo_header_separator.png"];
//    [tableHeaderView addSubview:separatorImage];
//    [separatorImage release];

    tableHeaderView.height += (_userBarView.height+h+10);
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
    
}

//取消网络请求
- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    /*
//     for (SinaWeiboRequest *request in self.requests) {
//     [request disconnect];
//     }
//     */
//    for (ASIHTTPRequest *request in self.requests) {
//        [request cancel];
//    }
    
}

#pragma mark - Data
- (void)loadData
{
    NSString *weiboId=[_weiboModel.weiboId stringValue];
    if (weiboId.length == 0) {
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    
     [self.sinaweibo requestWithURL:@"comments/show.json"
                             params:params
                         httpMethod:@"GET" block:^(NSDictionary *result) {
                             [self loadDataFinish:result];
                         }];
    
}

- (void)loadDataFinish:(NSDictionary *)result
{
    NSArray *array = [result objectForKey:@"comments"];
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *commentDic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:commentDic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    self.tableView.data = comments;
    //评论数
    self.tableView.commentDic = result;
    
    //刷新
    [self.tableView reloadData];
}

- (void)reloadUserImage
{
//    __block DetailViewController *this = self;
//    self.userImageView.touchBlock = ^{
//        NSString *nickName = this.weiboModel.user.screen_name;
//        UserViewController *userCtrl = [[[UserViewController alloc] init] autorelease];
//        userCtrl.userName = nickName;
//        [this.navigationController pushViewController:userCtrl animated:YES];
//    };
}



//上拉请求数据
- (void)pullUpData
{
    if (self.lastCommentId.length==0) {
        NSLog(@"评论id为空");
        return;
    }
    
    NSString *weiboId=[self.weiboModel.weiboId stringValue];
    if (weiboId.length==0) {
        return;
    }
    
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",weiboId,@"id",self.lastCommentId,@"max_id",nil];
    /*
     SinaWeiboRequest *request=[self.sinaweibo requestWithURL:@"comments/show.json"
     params:params
     httpMethod:@"GET"
     block:^(id result){
     [self pullUpDataFinish:result];
     }];
     [self.requests addObject:request];
     */
//    ASIHTTPRequest *request=[DataService requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" completeBlock:^(id result) {
//        [self pullUpDataFinish:result];
//    }];
//    [self.requests addObject:request];
}

- (void)pullUpDataFinish:(id)result
{
    NSArray *commentList=[result objectForKey:@"comments"];
    NSMutableArray *comments=[NSMutableArray arrayWithCapacity:commentList.count];
    
    for (NSDictionary *commentDic in commentList) {
        CommentModel *comment=[[[CommentModel alloc] initWithDataDic:commentDic] autorelease];
        [comments addObject:comment];
    }
    
    if (commentList.count>=20) {
        self.tableView.isMore=YES;
    }else{
        self.tableView.isMore=NO;
    }
    
    if (commentList.count>0) {
        //移除第一个重复的（这是新浪微博接口的问题）
        [comments removeObjectAtIndex:0];
        CommentModel *lastComment=[comments lastObject];
        self.lastCommentId=[lastComment.id stringValue];
    }
    
    //追加数组
    [self.comments addObjectsFromArray:comments];
    self.tableView.data=self.comments;
    
    
    //刷新
    [self.tableView reloadData];
}

#pragma mark - BaseTablViewEventDelegate
//下拉
- (void)pullDown:(BaseTableView *)tableView
{
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2];
}

//上拉
- (void)pullUp:(BaseTableView *)tableView
{
    [self pullUpData];
}

//选中
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
