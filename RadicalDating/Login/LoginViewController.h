//
//  LoginViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardManager.h"
#import "ModalSubscribe.h"
#import "constants.h"
#import "UITextField+Shake.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *BtnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;


#pragma mark - Action Outlets

- (IBAction)actionBtnHome:(id)sender;
- (IBAction)actionBtnLogin:(id)sender;
- (IBAction)actionbtnPrevious:(id)sender;


@end
