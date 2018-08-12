//
//  WebViewController.m
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/12.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleName;
    NSURL *url = [NSURL URLWithString:self.sourceUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}




@end
