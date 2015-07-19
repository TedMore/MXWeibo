//
//  CommentCell.h
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CommentModel.h"

@interface CommentCell : UITableViewCell <RTLabelDelegate> {
    UIImageView *_userImage;
    UILabel *_nickLabel;
    UILabel *_timeLabel;
    RTLabel *_contentLabel;
}

@property (nonatomic, retain) CommentModel *commentModel;

//计算评论单元格高度
+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
