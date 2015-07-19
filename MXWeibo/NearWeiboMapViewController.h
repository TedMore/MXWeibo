//
//  NearWeiboMapViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/18/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearWeiboMapViewController : BaseViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end
