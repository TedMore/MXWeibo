//
//  MXFaceScrollView.h
//  MXWeibo
//
//  Created by TedChen on 7/15/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXFaceView.h"

@interface MXFaceScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) MXFaceView *faceView;
@property (nonatomic, retain) UIPageControl *pageControl;

- (id)initWithSelectBlock:(SelectBlock)block;

@end
