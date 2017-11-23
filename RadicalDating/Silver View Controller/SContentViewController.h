//
//  SContentViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface SContentViewController : UIViewController <UIWebViewDelegate>

@property(strong,nonatomic)NSString *urlContent;

#pragma mark - Method

-(void)sendData:(NSArray*)content;
@property NSString *titleArticle;

#pragma mark - Properties

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


#pragma mark - Action Outlets

- (IBAction)actionBtnNext:(id)sender;
- (IBAction)actionBtnBack:(id)sender;

- (IBAction)actionBtnPrevious:(id)sender;
- (IBAction)actionBtnHome:(id)sender;

- (IBAction)actionBtnFb:(id)sender;

@end
