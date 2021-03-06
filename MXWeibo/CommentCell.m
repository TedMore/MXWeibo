//
//  CommentCell.m
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "UserViewController.h"
#import "WebViewController.h"
#import "NSString+URLEncoding.h"


@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}

- (void)awakeFromNib {
    _userImage = [(UIImageView *)[self viewWithTag:100] retain];
    _nickLabel = [(UILabel *)[self viewWithTag:101] retain];
    _timeLabel = [(UILabel *)[self viewWithTag:102] retain];
    _contentLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.delegate = self;
    
    //设置链接的颜色
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置链接高亮的颜色
    _contentLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_contentLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //头像
    NSString *userImageUrl = self.commentModel.user.profile_image_url;
    //加载网络图片
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
    _userImage.layer.cornerRadius = 5;
    _userImage.layer.masksToBounds = 5;
    
    //昵称
    _nickLabel.text = self.commentModel.user.screen_name;
    
    //时间 01-25 22:22
    _timeLabel.text = [UIUtils fomateString:self.commentModel.created_at];
    
    //内容
    _contentLabel.frame = CGRectMake(_userImage.right+10, _nickLabel.bottom+5, 240, 21);
    NSString *commentText = self.commentModel.text;
    commentText = [UIUtils parseLink:commentText];
    _contentLabel.text = commentText;
    _contentLabel.height = _contentLabel.optimumSize.height;
}

- (void)dealloc {
    [_userImage release];
    [_nickLabel release];
    [_timeLabel release];
    [_contentLabel release];
    [super dealloc];
}

+ (float)getCommentHeight:(CommentModel *)commentModel {
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.text = commentModel.text;
    rt.font = [UIFont systemFontOfSize:14.0f];
    return rt.optimumSize.height + 20;
}

#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        if (urlString.length > 0) {
            UserViewController *userViewCtrl = [[UserViewController alloc] init];
            [self.viewController.navigationController pushViewController:userViewCtrl animated:YES];
            userViewCtrl.userName = [urlString substringFromIndex:1];
            [userViewCtrl release];
        }
        NSLog(@"用户：%@", urlString);
    }
    else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"连接：%@", absoluteString);
        WebViewController *webViewCtrl = [[WebViewController alloc] initWithUrl:absoluteString];
        [self.viewController.navigationController pushViewController:webViewCtrl animated:YES];
        [webViewCtrl release];
    }
    else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *urlString = [url host];
        urlString = [urlString URLDecodedString];
        NSLog(@"话题：%@", urlString);
    }
}

@end
