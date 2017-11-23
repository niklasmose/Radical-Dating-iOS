//
//  GContentViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 09/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface GContentViewController : UIViewController<UIWebViewDelegate>

#pragma mark - Public Methods

-(void)sendContent:(NSArray*)content;
-(void)sendUrl:(NSString*)url;

@property NSString *titleArticle;

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

#pragma mark - ActionOutlets

- (IBAction)actionBtnPrevious:(id)sender;
- (IBAction)actionBtnFb:(id)sender;
- (IBAction)actionBtnHome:(id)sender;

@end
