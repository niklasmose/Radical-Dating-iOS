
//  MainMenuViewController.h
//  RadicalDating

//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import <UIKit/UIKit.h>
#import "ModalSubscribe.h"

#import "constants.h"
#import "alertView.h"

#import "RTSpinKitView.h"
#import "RDIAPHelper.h"
#import "LoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MainMenuViewController : UIViewController<UITextFieldDelegate,AlertViewDelegate,customDelegate,LoaderDelgate >


#pragma mark - properties

@property FBSDKLoginManager *login;
@property RTSpinKitView * spinner;

@property(nonatomic,strong)NSString *priceBronze;
@property(nonatomic,strong)NSString *priceSilver;
@property(nonatomic,strong)NSString *priceGold;

@property(nonatomic,strong)NSString *statusBronze;
@property(nonatomic,strong)NSString *statusSilver;
@property(nonatomic,strong)NSString *statusGold;

@property(nonatomic,strong)NSString *deviceId;

@property (weak, nonatomic) IBOutlet UIView *imgSplash;
@property (weak, nonatomic) IBOutlet UIView *viewActivity;


#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIButton *btnBronze;
@property (weak, nonatomic) IBOutlet UIView *viewBronze;
@property (weak, nonatomic) IBOutlet UIView *viewSilver;
@property (weak, nonatomic) IBOutlet UIView *viewGold;


#pragma mark - actions

- (IBAction)actionBtnBronze:(id)sender;
- (IBAction)actionBtnSilver:(id)sender;
- (IBAction)actionBtnGold:(id)sender;

- (IBAction)actionBtnFb:(id)sender;



@end
