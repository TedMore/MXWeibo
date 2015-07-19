//
//  MXFaceView.h
//  MXWeibo
//
//  Created by TedChen on 7/15/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock)(NSString *faceName);

@interface MXFaceView : UIView

@property (nonatomic, retain) NSMutableArray *items;        //表情数组
@property (nonatomic, retain) UIImageView *magnifierView;   //放大镜
@property (nonatomic, copy) NSString *selectFaceName;       //选中的表情
@property (nonatomic, assign) NSInteger pageNumber;         //数组的数量
@property (nonatomic, copy) SelectBlock selectBlock;

@end
