//
//  eBookViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 14/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "eBookViewController.h"

@interface eBookViewController (){
    
    UIActivityIndicatorView *activity;
    
    NSString *filePath;
}

@end

@implementation eBookViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setActivityIndicator];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadPDF];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Basic setup
-(void)setActivityIndicator{
    
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    [self.view addSubview:activity];
    [activity hidesWhenStopped];
    
    [activity startAnimating];
}


-(void)loadPDF{
    
    
    [_webView setDelegate:self];
    [_webView setScalesPageToFit:YES];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

   filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],@"RD.pdf"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    if (data!=nil) {
        
        [activity stopAnimating];
        
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    }
    else{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],@"RD.pdf"];
        
        // Download and write to file
        NSURL *urll = [NSURL URLWithString:_url];
        NSData *urlData = [NSData dataWithContentsOfURL:urll];
        [urlData writeToFile:filePath atomically:YES];
        
        [activity stopAnimating];

        // Load file in UIWebView
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    
    }
}


#pragma mark -Web View Method
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
        activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity setFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-10, 25, 25)];
        [self.view addSubview:activity];
        [activity hidesWhenStopped];
    [activity startAnimating];

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [activity stopAnimating];
}

#pragma mark - Action Button
- (IBAction)actionBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
