//
//  WeiboAnnotation.m
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (id)initWithWeibo:(WeiboModel *)weibo {
    self=[super init];
    if (self) {
        self.weiboModel = weibo;
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    //获取经纬度
    //有时返回"null",会被解析成 NSNull
    NSDictionary *geo = weiboModel.geo;
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coord = [geo objectForKey:@"coordinates"];
        if (coord.count == 2) {
            float lat = [[coord objectAtIndex:0] floatValue];
            float lon = [[coord objectAtIndex:1] floatValue];
            //self.coordinate=CLLocationCoordinate2DMake(lat, lon);
            //注：不能使用self.coordinate,它是readonly,没有set方法
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
    }    
}

@end
