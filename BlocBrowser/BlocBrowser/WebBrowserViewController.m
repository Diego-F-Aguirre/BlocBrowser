//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Diego Aguirre on 2/19/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebBrowserViewController

-(void)loadView {
    UIView *maineView = [UIView new];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    NSString *urlString = @"http://wikipedia.org";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [maineView addSubview:self.webView];
    
    self.view = maineView;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.frame;
}



@end
