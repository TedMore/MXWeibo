//
//  UserGridView.h
//  MXWeibo
//
//  Created by TedChen on 7/17/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserGridView : UIView

@property (nonatomic, retain) UserModel *userModel;
@property (nonatomic, retain) IBOutlet UILabel *nickLabel;
@property (nonatomic, retain) IBOutlet UILabel *fansLabel;
@property (nonatomic, retain) IBOutlet UIButton *imageButton;

- (IBAction)userImageAction:(id)sender;

@end
