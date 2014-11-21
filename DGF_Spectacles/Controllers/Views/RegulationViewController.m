//
//  RegulationViewController.m
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/14/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import "RegulationViewController.h"
#define DGF_ROOT_PAGE @"http://www.fgc.ca.gov/regulations/current/mammalregs.aspx"
#define DGF_ZONE_MAP @"http://www.dfg.ca.gov/wildlife/hunting/deer/cazonemap.html"
#define DFG_FEES @"http://www.fgc.ca.gov/regulations/current/mammalregs.aspx#702"

@interface RegulationViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webview;
@property (nonatomic) int pageIndex;
@property (strong, nonatomic) UIView *loadingView;
@end

@implementation RegulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    spinner.center = self.view.center;
    self.loadingView.center = self.view.center;
    [self.view addSubview:self.loadingView];
    [self.view addSubview:spinner];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    if (self.pageIndex == 1) {
        NSURL *url = [NSURL URLWithString:DGF_ROOT_PAGE];
        NSURLRequest *requestedPage = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:requestedPage];
    }
    else {
        NSURL *url = [NSURL URLWithString:DFG_FEES];
        NSURLRequest *requestedPage = [[NSURLRequest alloc]initWithURL:url];
        [self.webview loadRequest:requestedPage];
    }

}

- (void)setDetailItem:(int)newDetailItem {
    self.pageIndex = newDetailItem;
    [self __loadWheel];
}

- (void)__loadWheel {
    self.loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.loadingView.backgroundColor = [UIColor lightGrayColor];
    self.loadingView.layer.cornerRadius = 5;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingView removeFromSuperview];
    [self.view addSubview:webView];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
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
