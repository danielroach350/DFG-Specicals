//
//  ZoneMapViewController.m
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/14/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import "ZoneMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ZoneMapViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *request;
@property (strong, nonatomic) UIView *loadingView;
@property (nonatomic) CGRect frame;
@end

@implementation ZoneMapViewController

- (void)initializeMapPDF:(NSString *)mapName {
    NSString *fileLoaction = [[NSBundle mainBundle] pathForResource:mapName ofType:@"pdf"];
    NSURL *fileURL = [NSURL URLWithString:fileLoaction];
    _request = [[NSURLRequest alloc]initWithURL:fileURL];
    [self __loadingView];
}


- (void)__loadingView {
    self.loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.loadingView.backgroundColor = [UIColor lightGrayColor];
    self.loadingView.layer.cornerRadius = 5;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(__dismisView)];
    swipeBack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeBack];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.view.center;
    self.loadingView.center = self.view.center;
    [spinner startAnimating];
    [self.view addSubview:self.loadingView];
    [self.view addSubview:spinner];
}

- (void)__dismisView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    //self.webView.center = self.view.center;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view addSubview:webView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
