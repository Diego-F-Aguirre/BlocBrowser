//
//  WebBrowserViewController.m
//  BlocBrowser
//
//  Created by Diego Aguirre on 2/19/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "AwesomeFloatingToolbar.h"

@interface WebBrowserViewController () <UIWebViewDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;

@property (nonatomic, assign) NSUInteger frameCount;

#define kBLCWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kBLCWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kBLCWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kBLCWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")

@end

@implementation WebBrowserViewController

#pragma mark - UIViewController

-(void)loadView {
    UIView *maineView = [UIView new];
    
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    
    self.textField = [[UITextField alloc]init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.placeholder = NSLocalizedString(@"Website URL or Search", @"Placeholder text for web browser URL field");
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    
    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[kBLCWebBrowserBackString, kBLCWebBrowserForwardString, kBLCWebBrowserStopString, kBLCWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    
    for (UIView *viewToAdd in @[self.webView, self.textField, self.awesomeToolbar]) {
        [maineView addSubview:viewToAdd];
    
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Welcome!", @"Welcome title") message:NSLocalizedString(@"Get excited to use the best browser ever!", @"Welcome comment") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK, I'm excited!", @"Welcome button title") otherButtonTitles:nil];
    
    [alert show];
    
    self.view = maineView;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    

    // Do any additional setup after loading the view.
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
  
    
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    self.awesomeToolbar.frame = CGRectMake(20, 100, 280, 60);
    }

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSString *URLString = textField.text;
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    if (!URL.scheme) {
        
        
//        NSRange urlSpace = [URLString rangeOfString:@" "];
//
//        NSString *urlNoSpace = [URLString stringByReplacingCharactersInRange:urlSpace withString:@"+"];
//
//        
//        if (URL != NSNotFound) {
//            URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", urlNoSpace]];
//
//        } else {
//        URL= [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",URLString]];
//            
//        }
        
        URL= [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",URLString]];
    }
    
    if (URL){
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    return NO;
    
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    self.frameCount++;
    [self updateButtonsAndTitle];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.frameCount--;
    [self updateButtonsAndTitle];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code != -999) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];
    }
    [self updateButtonsAndTitle];
    self.frameCount--;
}

#pragma mark - Miscellaneous

-(void) updateButtonsAndTitle {

    NSString *webpageTitle= [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if (webpageTitle) {
        self.title = webpageTitle;
    } else {
        self.title = self.webView.request.URL.absoluteString;
    }
    
    if (self.frameCount > 0) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    [self.awesomeToolbar setEnabled:[self.webView canGoBack] forButtonWithTitle:kBLCWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kBLCWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:self.frameCount > 0 forButtonWithTitle:kBLCWebBrowserStopString];
    [self.awesomeToolbar setEnabled:self.webView.request.URL && self.frameCount == 0 forButtonWithTitle:kBLCWebBrowserRefreshString];
}



-(void)resetWebView{
    [self.webView removeFromSuperview];
    
    UIWebView *newWebView = [[UIWebView alloc]init];
    newWebView.delegate = self;
    [self.view addSubview:newWebView];
    
    self.webView = newWebView;
    
    
    
    self.textField.text = nil;
    [self updateButtonsAndTitle];
}

#pragma mark - AwesomeFloatingToolbarDelegate

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    if ([title isEqual:NSLocalizedString(@"Back", @"Back command")]) {
        [self.webView goBack];
    } else if ([title isEqual:NSLocalizedString(@"Forward", @"Forward command")]) {
        [self.webView goForward];
    } else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    } else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
}



@end
