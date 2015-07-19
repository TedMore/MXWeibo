//
//  DiscoverViewController.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiboMapViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    for (int i=100; i<102; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(2, 2);
        button.layer.shadowOpacity = 1;
        button.layer.shadowRadius = 3;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nearWeiboButton release];
    [_nearUserButton release];
    [super dealloc];
}

- (IBAction)nearWeiboAction:(id)sender {
    NearWeiboMapViewController *nearCtrl = [[NearWeiboMapViewController alloc] init];
    [self.navigationController pushViewController:nearCtrl animated:YES];
    [nearCtrl release];
}

- (IBAction)nearUserAction:(id)sender {
    
}
@end
