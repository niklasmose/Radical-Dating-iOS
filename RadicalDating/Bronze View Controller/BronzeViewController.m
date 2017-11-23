
//  BronzeViewController.m
//  RadicalDating

//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import "BronzeViewController.h"

@interface BronzeViewController (){
    
    NSArray *arrayPickUpLines;
    
    UIActivityIndicatorView *activity;    
}

@end

@implementation BronzeViewController

#pragma mark - View cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self hitAPI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    if ([_spinner isAnimating]) {
        
        [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height*3/4, 25, 25)];
        
//        [_spinner setFrame:CGRectInset(self.view.frame, 0, 0)];
    }

}

#pragma mark - Basic setup
-(void)setUI{
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnNext.layer setCornerRadius:5.0f];
    
    [self setActivityIndicator];
}

-(void)setActivityIndicator{
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce color:[UIColor whiteColor]];
    
    [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height*3/4, 25, 25)];
    
    [self.view addSubview:_spinner];
    [_spinner hidesWhenStopped];
    
    [_spinner stopAnimating];
}

#pragma mark - Hit Api
-(void)hitAPI{
    
    if (![self internetWorking]) {
        
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:nil subTitle:@"Internet is not working" closeButtonTitle:@"Ok" duration:5.0f];
    }
    else{
        
        [_spinner startAnimating];
        
        [ModalBronze getPickUpText:urlPickUpText :^(NSArray *response_success) {
            
            [_spinner stopAnimating];
            
            arrayPickUpLines = [[NSArray alloc]initWithArray:response_success];
            
            [self.lblPickUpLine setText:[self getRandomPickUpLine]];
            
        } :^(NSString *response_error) {
            
            [_spinner stopAnimating];
            
            [self.lblPickUpLine setText:[NSString stringWithFormat:@"%@",response_error]];
            
           //NSLog(@"%@",response_error);
        }];
    }
}

#pragma mark - Reachability

-(BOOL)internetWorking{
    
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        
        return NO;
    }
    else{
        
        return YES;
    }
}

-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([msg isEqualToString:@"Your response has been recorded!"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Action
- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }

}

- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)actionBtnNext:(id)sender {
    
    if (arrayPickUpLines!=nil) {
        
        [self.lblPickUpLine setText:[self getRandomPickUpLine]];
    }
}

#pragma mark - random pickup line method
-(NSString*)getRandomPickUpLine{
    
    ModalBronze *data;
    
        int limit = (int)arrayPickUpLines.count;
        data = [arrayPickUpLines objectAtIndex:rand()%limit];
       //NSLog(@"%@",data.pickUpLine);
      
    return data.pickUpLine;
}

@end
