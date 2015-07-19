//
//  DiscoverViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"

@interface DiscoverViewController : BaseViewController
@property (retain, nonatomic) IBOutlet UIButton *nearWeiboButton;
@property (retain, nonatomic) IBOutlet UIButton *nearUserButton;

- (IBAction)nearWeiboAction:(id)sender;
- (IBAction)nearUserAction:(id)sender;
@end
