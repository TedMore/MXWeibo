//
//  BrowModeController.m
//  MXWeibo
//
//  Created by TedChen on 7/12/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BrowModeController.h"
#import "UIFactory.h"
#import "CONSTS.h"

@interface BrowModeController ()

@end

@implementation BrowModeController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"图片浏览模式";
}

#pragma mark - UITableView Degelate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier=@"modeCell";
//    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell==nil) {
//        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
//        
//        UILabel *textLabel=[UIFactory createLabel:kThemeListLabel];
//        textLabel.frame=CGRectMake(10, 10, 200, 30);
//        textLabel.backgroundColor=[UIColor clearColor];
//        textLabel.font=[UIFont boldSystemFontOfSize:16.0f];
//        textLabel.tag=2013;
//        [cell.contentView addSubview:textLabel];
//    }
//    //cell.textLabel.text=self.themes[indexPath.row];
//    
//    UILabel *textLabel=(UILabel *)[cell.contentView viewWithTag:2013];
//    NSString *textName=self.modes[indexPath.row];
//    textLabel.text=textName;
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图";
        cell.detailTextLabel.text = @"所有网络加载大图";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"小图";
        cell.detailTextLabel.text = @"所有网络加载小图";
    }
    
//    int mode=[[NSUserDefaults standardUserDefaults] integerForKey:kModeName];
//    if (mode==nowMode) {
//        cell.accessoryType=UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType=UITableViewCellAccessoryNone;
//    }
    
    return cell;
}

//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int mode = -1;
    if (indexPath.row == 0) {
        mode = LargeBrowMode;
    }else if (indexPath.row == 1){
        mode = SmallBrowMode;
    }
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //刷新微博列表
    //注：这种场景下，HomeViewController与BrowModeController完全扯不上关系，不能使用delegate,或者block。只能使用通知。
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - dealloc/memoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
