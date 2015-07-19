//
//  InterfaceImageView.h
//  MXWeibo
//
//  Created by TedChen on 7/13/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(void);

@interface InterfaceImageView : UIImageView

@property (nonatomic, copy) ImageBlock touchBlock;

@end
