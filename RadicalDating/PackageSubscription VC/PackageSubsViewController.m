//
//  PackageSubsViewController.m
//  RadicalDating
//
//  Created by Aseem 2 on 03/05/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "PackageSubsViewController.h"

@interface PackageSubsViewController (){
    
    NSArray *arrayProducts;
}

@end

@implementation PackageSubsViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Set UI
-(void)setUI{
    
    [self.lblPackage setText:self.packageName];
    
    [self.btnContinue.layer setCornerRadius:5.0f];
    [self.btnFacebok.layer setCornerRadius:5.0f];
    
    self.navigationController.title = @"silver";
}

-(void)setupFBLogin{
    
    _loginButton = [[FBSDKLoginButton alloc] init];
    _loginButton.center = self.view.center;
    [self.view addSubview:_loginButton];
    
    _loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
}

-(BOOL)checkValidation{
    
    if (![self NSStringIsValidEmail:_txtEmail.text]) {
        
        [self showAlert:@"Please enter valid email id"];
    }
    else if ([[_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    
        [self showAlert:@"Please enter name"];
    
    else {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - alert
-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    
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

-(void)fetchAndBuy{
    
    [[RDIAPHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
        
        NSLog(@"%@",products);
        
        arrayProducts = [[NSArray alloc] initWithArray:products];
        
        [[RDIAPHelper sharedInstance] buy_Product:[products firstObject]];
        
        NSLog(@"\n\nsuccessful");
    }];
}

-(void)hitApiNewsLetter{
    
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceId"];
    NSString *email = [NSString stringWithString:_txtEmail.text];
    NSString *name = [NSString stringWithString:_txtName.text];
    
    [_txtEmail setText:nil];
    [_txtName setText:nil];
    
    [ModalSubscribe sendDetails:urlSubscribe :@{@"device_id":deviceId, @"email":email,@"name":name}:^(NSDictionary *response_success) {
        
        [self fetchAndBuy];

    } :^(NSString *response_error) {
        
        [self showAlert:@"Error!\nPlease try again"];
        
    }];

}

#pragma mark - Actions

- (IBAction)actionBtnContinue:(id)sender {
    
//    if ([self checkValidation]) {
    
        [self fetchAndBuy];
//    }
}

- (IBAction)actionBtnFBLogin:(id)sender {
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    [loginManager logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
            NSLog(@"Process error");
            
        } else if (result.isCancelled) {
            
            NSLog(@"Cancelled");
            
        } else {
            
            NSLog(@"Logged in");
        }
    }];
    
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"%@",result[@"email"]);
                 
                 NSLog(@"%@",[result valueForKey:@"name"]);
                 
                 [_txtName setText:result[@"name"]];
                 [_txtEmail setText:result[@"email"]];
             }
         }];
    }
}


- (IBAction)btnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showAlert:(NSString*)title with:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:OKAction];
    [alertController addAction:CancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
