//
//  eBookViewController.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 14/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eBookViewController : UIViewController<UIWebViewDelegate>

#pragma mark - Properties

@property(strong,nonatomic)NSString *url;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


#pragma mark - Action
- (IBAction)actionBtnBack:(id)sender;

@end
