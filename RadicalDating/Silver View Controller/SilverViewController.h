//
//  SilverViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalSilver.h"
#import "SContentViewController.h"
#import "constants.h"
#import "SilverTableViewCell.h"
#import "eBookViewController.h"
#import "RTSpinKitView.h"


@interface SilverViewController : UIViewController<UIDocumentInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource>

#pragma mark - Properties

@property RTSpinKitView * spinner;

@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UITableView *tableViewS;
@property (weak, nonatomic) IBOutlet UITextView *textResponse;


#pragma mark - Actions

- (IBAction)actionBtnHome:(id)sender;
- (IBAction)actionBtnFb:(id)sender;

@end
