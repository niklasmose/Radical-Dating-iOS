//
//  PackageSubsViewController.h
//  RadicalDating
//
//  Created by Aseem 2 on 03/05/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RDIAPHelper.h"
#import "ModalSubscribe.h"

@interface PackageSubsViewController : UIViewController

@property(strong,nonatomic) NSString *packageName;

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebok;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UILabel *lblPackage;


@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *btnFBLogin;

- (IBAction)actionBtnFBLogin:(id)sender;
- (IBAction)actionBtnContinue:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
