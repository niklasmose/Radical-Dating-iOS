
//  GoldViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import <UIKit/UIKit.h>
#import "ModalGold.h"
#import "constants.h"
#import "GAudioViewController.h"
#import "RTSpinKitView.h"
#import "GArticleViewController.h"

@interface GoldViewController : UIViewController

#pragma mark- Properties

@property RTSpinKitView * spinner;

@property (weak, nonatomic) IBOutlet UITextView *textResponse;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIImageView *imgArticle;
@property (weak, nonatomic) IBOutlet UIImageView *imgAudio;

@property (weak, nonatomic) IBOutlet UIView *viewArticle;
@property (weak, nonatomic) IBOutlet UIView *viewAudio;

#pragma mark - Actions

- (IBAction)actionbtnHome:(id)sender;
- (IBAction)actionBtnFb:(id)sender;

@end
