//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Diego Aguirre on 2/19/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation WebBrowserViewController

-(void)loadView {
    UIView *maineView = [UIView new];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    self.textField = [[UITextField alloc]init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    NSString *urlString = @"http://wikipedia.org";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [maineView addSubview:self.webView];
    [maineView addSubview:self.textField];
    
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
