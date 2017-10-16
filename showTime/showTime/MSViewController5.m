//
//  MSViewController5.m
//  showTime
//
//  Created by msj on 2017/3/17.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSViewController5.h"

@interface MSViewController5 ()
@property (strong, nonatomic) UIWebView *webview;

@end

@implementation MSViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webview];
    
    
    self.navigationItem.title = self.message;
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.message]];
    [self.webview loadRequest:req];
    
}

@end
