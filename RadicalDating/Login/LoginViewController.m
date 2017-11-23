//
//  LoginViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -Set UI
-(void)setUI{
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnScreen)];
    [self.view addGestureRecognizer:tap];
    
    [self.txtName setDelegate:self];
    [self.txtName.layer setCornerRadius:5.0f];
    self.txtName.layer.borderWidth = 1.0f;
    self.txtName.layer.borderColor = [UIColor colorWithRed:95.0f/255 green:14.0f/255 blue:20.0f/255 alpha:1.0f].CGColor;
    [self.txtName setValue:[UIColor colorWithRed:43.0f/255 green:45.0f/255 blue:48.0f/255 alpha:1.0f]
                forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.txtEmail setDelegate:self];
    self.txtEmail.layer.borderWidth = 1.0f;
    self.txtEmail.layer.borderColor = [UIColor colorWithRed:95.0f/255 green:14.0f/255 blue:20.0f/255 alpha:1.0f].CGColor;
    [self.txtEmail.layer setCornerRadius:5.0f];
    [self.txtEmail setValue:[UIColor colorWithRed:43.0f/255 green:45.0f/255 blue:48.0f/255 alpha:1.0f]
                forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnPrevious.layer setBorderWidth:0.5f];
    [self.btnPrevious.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnPrevious.layer setCornerRadius:5.0f];
    
    [self.BtnLogin.layer setCornerRadius:5.0f];

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

#pragma mark - action buttons

- (IBAction)actionBtnHome:(id)sender {
        
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)actionBtnLogin:(id)sender {
    
    if (![self internetWorking]) {
        
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:nil subTitle:@"Internet is not working" closeButtonTitle:@"Ok" duration:5.0f];
    }
    else{
        
        NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:deviceID];
        NSString *email = [NSString stringWithString:[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        NSString *name = [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
        if (![self NSStringIsValidEmail:email]) {
            
            [_txtEmail shake:10 withDelta:5];
            [self showAlert:@"Please enter valid email id"];
        }
        else if ([name isEqualToString:@""]) {
            
            [_txtName shake:10 withDelta:5];
            [self showAlert:@"Please enter name"];
        }
        else{
            
            [_txtEmail setText:nil];
            [_txtName setText:nil];
            
            [ModalSubscribe sendDetails:urlSubscribe :@{@"device_id":deviceId, @"email":email,@"name":name}:^(NSDictionary *response_success) {
                
                [self showAlert:[NSString stringWithFormat:@"Dear %@!\nYour response has been recorded",name]];
                
            } :^(NSString *response_error) {
                
                [self showAlert:@"Error!"];
                
            }];
        }
    }
}

- (IBAction)actionbtnPrevious:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alert
-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
 
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([msg containsString:@"Your response has been recorded!"]) {
//         
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }];
    
   
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)tapOnScreen{
    
    [self.txtEmail resignFirstResponder];
    [self.txtName resignFirstResponder];
}

#pragma mark -TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.txtName) {
        [textField resignFirstResponder];
    }
    else{
        [self.txtName becomeFirstResponder];
    }
    
    return YES;
}


@end
