//
//  WebViewController.h
//  MXWeibo
//
//  Created by TedChen on 7/13/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController <UIWebViewDelegate> {
    NSString *_url;
}

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reload:(id)sender;
- (id)initWithUrl:(NSString *)url;

@end
