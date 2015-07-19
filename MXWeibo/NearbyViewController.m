//
//  NearbyViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/14/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "MXDataService.h"


@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = NO;
        self.isCancelButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我在这里";
    self.tableView.hidden = YES;
    [super showLoading:YES];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //IOS8.0需要请求授权
    [locationManager requestWhenInUseAuthorization];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
}

- (void)dealloc {
    [_tableView release];
    [_data release];
    self.selectBlock = nil;
    [super dealloc];
}

#pragma mark - CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [manager stopUpdatingLocation];
    NSLog(@"%@", locations);
    CLLocation *newLocation = [locations firstObject];
    if (self.data == nil) {
        //经度
        float longitude = newLocation.coordinate.longitude;
        //维度
        float latitude = newLocation.coordinate.latitude;
        NSString *longitudeString = [NSString stringWithFormat:@"%f",longitude];
        NSString *latitudeString = [NSString stringWithFormat:@"%f",latitude];
        
        
        NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString,@"long",latitudeString,@"lat", nil];
        
//        [self.sinaweibo requestWithURL:@"place/nearby/pois.json"
//                                params:params
//                            httpMethod:@"GET" block:^(id result) {
//                                [self loadNearbyDataFinish:result];
//                            }];
        [MXDataService requestWithURL:URL_POIS
                               params:params
                           httpMethod:@"GET" completeBlock:^(id result) {
                               [self loadNearbyDataFinish:result];
                           }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location error:%@",error);
}

#pragma mark - UI
- (void)refreshUI {
    self.tableView.hidden = NO;
    [super showLoading:NO];
    [self.tableView reloadData];
}

#pragma mark - Data
- (void)loadNearbyDataFinish:(NSDictionary *)result {
    NSArray *pois = [result objectForKey:@"pois"];
    self.data = pois;
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc
                 ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    //数据
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    return cell;
}

//调整高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock != nil) {
        NSDictionary *dic = self.data[indexPath.row];
        self.selectBlock(dic);
        //注：如果调用多次,则不能再次释放block；如果调用一次，则可以在这里释放
        //关闭模态视图
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
