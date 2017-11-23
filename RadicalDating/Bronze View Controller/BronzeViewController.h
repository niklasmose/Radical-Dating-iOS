//  BronzeViewController.h
//  RadicalDating

//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import <UIKit/UIKit.h>
#import "ModalBronze.h"
#import "constants.h"
#import "RTSpinKitView.h"

@interface BronzeViewController : UIViewController

#pragma mark - Properties

@property RTSpinKitView * spinner;


#pragma mark - IBOutlets

@property (strong, nonatomic) IBOutlet UILabel *lblPickUpLine;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;


#pragma mark - Actions

- (IBAction)actionBtnFb:(id)sender;
- (IBAction)actionBtnHome:(id)sender;
- (IBAction)actionBtnNext:(id)sender;

@end
