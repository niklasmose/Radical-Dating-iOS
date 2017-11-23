//
//  alertView.h
//  RadicalDating
//
//  Created by Aseem 2 on 23/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardManager.h"

@protocol AlertViewDelegate

@optional

-(void)actionBtnBuy;
-(void)actionBtnRestore;
-(void)actionBtnFacebook;
@end

@interface alertView : UIView<UITextFieldDelegate>

#pragma mark - Properties

@property (nonatomic,assign) id <AlertViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIView *viewAlert;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;

#pragma mark -Action OUTlets

- (IBAction)backgroundTouch:(id)sender;
- (IBAction)actionBtnok:(id)sender;
- (IBAction)actionBtnCancel:(id)sender;
- (IBAction)actionBtnFacebook:(id)sender;
- (IBAction)actionBtnRestore:(id)sender;


@end
