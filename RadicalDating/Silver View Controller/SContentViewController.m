//
//  SContentViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "SContentViewController.h"

@interface SContentViewController (){
    
    NSArray *contentData;
    int count;
}

@end

@implementation SContentViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self manageUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Basic setup
-(void)setUI{
    
    [_lblTitle setText:_titleArticle];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnPrevious.layer setBorderWidth:0.5f];
    [self.btnPrevious.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnPrevious.layer setCornerRadius:5.0f];
    
    [_webView.scrollView setBounces:NO];
    _webView.contentMode = UIViewContentModeTop;
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(16.0, 16.0f, 0.0f, 16.0f)];
    
    if (contentData!=nil) {
        
        NSString *htmlString = [contentData objectAtIndex:0];
        [_webView loadHTMLString:htmlString baseURL:nil];
        
        count = 0;
    }
}


-(void)manageUI{
    
    [_btnNext setAlpha:0.3f];
    [_btnBack setAlpha:0.3f];
    
    if (contentData.count>1) {
        [_btnNext setAlpha:1.0f];
    }
}

#pragma mark - Action Button
- (IBAction)actionBtnNext:(id)sender {
    
    if (count<contentData.count-1) {
        
        NSString *htmlString = [contentData objectAtIndex:++count];
        
        [_webView loadHTMLString:htmlString baseURL:nil];
        
        [_btnBack setAlpha:1.0f];
    }
    
    if (count==contentData.count-1) {
        [_btnNext setAlpha:0.3f];
    }
    
}

- (IBAction)actionBtnBack:(id)sender {
    if (count>0) {
        
        NSString *htmlString = [contentData objectAtIndex:--count];
        
        [_webView loadHTMLString:htmlString baseURL:nil];

        [_btnNext setAlpha:1.0f];
    }
    
    if (count==0) {
        [_btnBack setAlpha:0.3f];
    }
}

- (IBAction)actionBtnPrevious:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
}

#pragma mark - Send Data
-(void)sendData:(NSArray *)content{
    
    if (content!=nil) {
        
        contentData = [NSArray arrayWithArray:content];

    }
}

@end
