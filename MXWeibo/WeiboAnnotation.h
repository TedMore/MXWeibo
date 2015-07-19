//
//  WeiboAnnotation.h
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, retain) WeiboModel *weiboModel;

- (id)initWithWeibo:(WeiboModel *)weibo;

@end
