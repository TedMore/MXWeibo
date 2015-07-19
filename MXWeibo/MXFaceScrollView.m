//
//  MXFaceScrollView.m
//  MXWeibo
//
//  Created by TedChen on 7/15/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "MXFaceScrollView.h"

@implementation MXFaceScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.faceView = [[MXFaceView alloc] initWithFrame:CGRectZero];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.faceView.height)];
    self.scrollView.contentSize = CGSizeMake(self.faceView.width, self.faceView.height);
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    //禁止水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //超出部分不裁剪
    self.scrollView.clipsToBounds = NO;
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.faceView];
    [self addSubview:self.scrollView];
    
    //翻页
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, 40, 20)];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = self.faceView.pageNumber;
    //初始为第0页
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    //当前视图的高度与宽度
    self.height = self.scrollView.height + self.pageControl.height;
    self.width = self.scrollView.width;
    //背景图片高度不足，图片背身又不能拉伸，这时，要用drawRect绘制背景图片
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background.png"]];
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}

- (void)dealloc {
    _scrollView = nil;
    _faceView = nil;
    _pageControl = nil;
    [super dealloc];
}

- (id)initWithSelectBlock:(SelectBlock)block {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.faceView.selectBlock = block;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //通过偏移量计算页数
    int pageNumber = scrollView.contentOffset.x/320;
    self.pageControl.currentPage = pageNumber;
}

@end
