//
//  GoldTableViewCell.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoldTableViewCell : UITableViewCell

#pragma mark - IBOutlets

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgArticle;


@end
