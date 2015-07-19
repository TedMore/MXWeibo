//
//  UserGridView.m
//  MXWeibo
//
//  Created by TedChen on 7/17/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "UserGridView.h"
#import "UIButton+WebCache.h"
#import "UserViewController.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        gridView.backgroundColor = [UIColor clearColor];
        self.size = gridView.size;
        [self addSubview:gridView];
        //背景图片
        UIImage *image = [UIImage imageNamed:@"profile_button3_1.png"];
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:image];
        backgroundView.frame = self.bounds;
        [self insertSubview:backgroundView atIndex:0];
        [backgroundView release];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];    
    //头像
    NSString *urlString = self.userModel.profile_image_url;
    [self.imageButton setImageWithURL:[NSURL URLWithString:urlString]];
    
    //昵称
    self.nickLabel.text = self.userModel.screen_name;
    //[self.nickLabel sizeToFit];
    
    //粉丝
    long fansL = [self.userModel.followers_count longValue];
    NSString *fans = [NSString stringWithFormat:@"%ld", fansL];
    if (fansL >= 10000) {
        fansL = fansL/10000.0;
        fans = [NSString stringWithFormat:@"%ld万", fansL];
    }
    self.fansLabel.text = fans;
    //[self.nickLabel sizeToFit];
}

- (void)dealloc {
    [_nickLabel release];
    [_fansLabel release];
    [_imageButton release];
    [super dealloc];
}

- (IBAction)userImageAction:(id)sender {
    UserViewController *userCtrl = [[UserViewController alloc] init];
    userCtrl.userName = self.userModel.screen_name;
    [self.viewController.navigationController pushViewController:userCtrl animated:YES];
    [userCtrl release];
}

@end
