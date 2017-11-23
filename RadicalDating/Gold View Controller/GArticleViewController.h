
//  GArticleViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import <UIKit/UIKit.h>
#import "GoldTableViewCell.h"
#import "ModalGold.h"
#import "constants.h"
#import "GContentViewController.h"
#import "RTSpinKitView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface GArticleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

#pragma mark - Properties

-(void)sendData:(NSArray *)arrayData;

@property RTSpinKitView * spinner;

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UITableView *tableViewGArticle;


#pragma mark - Actions

- (IBAction)actionBtnHome:(id)sender;
- (IBAction)actionBtnPrevious:(id)sender;
- (IBAction)actionFbBtn:(id)sender;


@end
