//
//  NearWeiboMapViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import "MXDataService.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()

@end

@implementation NearWeiboMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //定位
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    //设置精度
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat", nil];
    [MXDataService requestWithURL:@"place/nearby_timeline.json"
                           params:params
                       httpMethod:@"GET" completeBlock:^(id result) {
                           [self loadNearWeiboDataFinish:result];
                       }];
    
}

- (void)loadNearWeiboDataFinish:(NSDictionary *)result
{
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    
    for (int i=0; i<statuses.count; i++) {
        NSDictionary *statuesDic = [statuses objectAtIndex:i];
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
        
        //创建Anatation对象，添加到地图上去
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] initWithWeibo:weibo];
        //延迟调用,可形成一个一个添加到地图上的动画效果
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation
                           afterDelay:i*0.05];
        //[self.mapView addAnnotation:weiboAnnotation];
    }
}

#pragma mark - CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [manager stopUpdatingLocation];
    NSLog(@"%@", locations);
    
    CLLocation *newLocation = [locations firstObject];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    MKCoordinateSpan span = {0.1, 0.1};
    MKCoordinateRegion region = {coordinate, span};
    [self.mapView  setRegion:region animated:YES];
    
    if (self.data == nil) {
        //经度
        float longitude = newLocation.coordinate.longitude;
        //维度
        float latitude = newLocation.coordinate.latitude;
        NSString *longitudeString = [NSString stringWithFormat:@"%f", longitude];
        NSString *latitudeString = [NSString stringWithFormat:@"%f", latitude];
        [self loadNearWeiboData:longitudeString latitude:latitudeString];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location error:%@",error);
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //判断是否是获得当前位置。如果是，则返回nil，让系统自己创建
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //在地图上为annotation显示WeiboAnnotationView视图
    static NSString *identify = @"WeiboAnnotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (annotationView == nil){
        annotationView = [[[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify] autorelease];
    }
    return annotationView;
}

//添加在mapView后会调用这个方法。可用于实现动画效果
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (UIView *annotationView in views) {
        //动画：先从0.7--到1.2；在从1.2--到1；形成气泡的效果
        //原始的transform
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            //动画1
            annotationView.transform = CGAffineTransformScale(transform, 1.3, 1.3);
            annotationView.alpha = 1;
        } completion:^(BOOL finished) {
            //动画2
            [UIView animateWithDuration:0.4 animations:^{
                //恢复到原始大小
                annotationView.transform = CGAffineTransformIdentity;
            }];
        }];
    }    
}

- (void)dealloc {
    [_mapView release];
    [super dealloc];
}

@end
