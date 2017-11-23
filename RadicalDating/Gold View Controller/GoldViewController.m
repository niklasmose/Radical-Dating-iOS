
//  GoldViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import "GoldViewController.h"

@interface GoldViewController (){
    
    NSString *urlAudio;
    
    NSMutableArray *arrayGData;
}

@end

@implementation GoldViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self hitAPI];
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
        
        [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    }
}
#pragma mark - Basic setup
-(void)setUI{
    
    arrayGData = [[NSMutableArray alloc] init];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    UITapGestureRecognizer *tapOnAudio = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AudioTapped)];
    UITapGestureRecognizer *tapOnArticle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ArticleTapped)];
    
    [self.imgAudio addGestureRecognizer:tapOnAudio];
    [self.imgArticle addGestureRecognizer:tapOnArticle];
    
    [self.viewArticle setHidden:YES];
    [self.viewAudio setHidden:YES];
    
    [self setActivityIndicator];
}

-(void)setActivityIndicator{
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce color:[UIColor whiteColor]];
    
    [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    
    [self.view addSubview:_spinner];
    [_spinner hidesWhenStopped];
}

-(void)hitAPI{
    
    if (![self internetWorking]) {
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:nil subTitle:@"Internet is not working" closeButtonTitle:@"Ok" duration:5.0f];
    }
    else{
    
        [_spinner startAnimating];
        
        [ModalGold getAudio : urlGoldContent:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSArray *response_success,NSDictionary* totalresponse) {

            [_spinner stopAnimating];
            
            [self.viewArticle setHidden:NO];
            [self.viewAudio setHidden:NO];
            
            arrayGData = response_success.mutableCopy;
                        
            ModalGold *audioData;
            
            for (audioData in response_success) {
                
                if ([audioData.mediaType isEqualToString:@"mp3"]) {
                    
                    urlAudio = [NSString stringWithString:audioData.mediaUrl];
                }
            }
            
        } :^(NSString *response_error) {

            [_spinner stopAnimating];
            
            [self showAlert:response_error];
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

#pragma mark - Audio Tapped
-(void)AudioTapped{
    
   //NSLog(@"Audio tapped!");
    
    [self performSegueWithIdentifier:@"audio" sender:urlAudio];
}

-(void)ArticleTapped{
    
   //NSLog(@"Article tapped!");
    
    [self performSegueWithIdentifier:@"article" sender:arrayGData];
}

-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self hitAPI];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    [alertController addAction:OKAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)actionbtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
    
}

#pragma mark - prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"audio"]) {
        
        GAudioViewController *vc = segue.destinationViewController;
        [vc sendAudio:sender];
    }
    
    else if ([segue.identifier isEqualToString:@"article"]){
        
        GArticleViewController *vc = segue.destinationViewController;
        [vc sendData:sender];
    }
}

@end
