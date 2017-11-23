//
//  GContentViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 09/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "GContentViewController.h"

@interface GContentViewController (){
    
    NSString *contentData;
    NSString *urlContent;
}

@end

@implementation GContentViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
//    [self.textViewContent setContentOffset:CGPointMake(0.0, 0.0) animated:NO];

}

-(void)viewDidLayoutSubviews{
    
    [self.textViewContent setContentOffset:CGPointMake(0.0, 0.0) animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Basic Methods
-(void)setUI{
    
    [_lblTitle setText:_titleArticle];
    
    [_webView.scrollView setBounces:NO];
    _webView.contentMode = UIViewContentModeTop;
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];
    [_webView.scrollView setContentInset:UIEdgeInsetsMake(16.0, 16.0f, 0.0f, 16.0f)];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnPrevious.layer setBorderWidth:0.5f];
    [self.btnPrevious.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnPrevious.layer setCornerRadius:5.0f];
    
    self.textViewContent.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.textViewContent setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
    if (contentData!=nil) {
        
        [_webView setHidden:YES];
        [self.textViewContent setText:contentData];
    }
    
    if (urlContent!=nil) {
        [_textViewContent setHidden:YES];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlContent]]];

        }
}

-(void)sendContent:(NSArray *)content{
    
    NSString *data;
    for (data in content) {
        
        contentData = [NSString stringWithFormat:@"%@",data];

    }
    
}

-(void)sendUrl:(NSString *)url{
    
    urlContent = [NSString stringWithString:url];
}

#pragma mark - Action Button
- (IBAction)actionBtnPrevious:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionBtnFb:(id)sender {
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
    
}

- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
