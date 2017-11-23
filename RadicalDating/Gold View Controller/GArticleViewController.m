
//  GArticleViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import "GArticleViewController.h"

@interface GArticleViewController (){
    
    NSMutableArray *arrayGArticle;
    NSArray *arrayImages;
    NSInteger tableViewHeight;
    NSString *selectedTitle;
}

@end

@implementation GArticleViewController

#pragma mark - view cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        tableViewHeight = self.view.frame.size.height/5;
        [_tableViewGArticle reloadData];
    }
    else
        tableViewHeight = self.view.frame.size.height/3;
    [_tableViewGArticle reloadData];

}


#pragma mark - set UI
-(void)setUI{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        tableViewHeight = self.view.frame.size.height/5;
    }
    else{
        tableViewHeight = self.view.frame.size.height/3;
    }
    arrayImages = [NSArray arrayWithObjects:@"img_1",@"img_2",@"img_3",@"img_4",@"img_5",@"img_6",@"img_7",@"img_8",@"img_9",@"img_10",@"img_11",@"img_12",@"img_13",@"img_14",@"img_15",@"img_16",@"img_17", nil];
    
    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self.btnPrevious.layer setBorderWidth:0.5f];
    [self.btnPrevious.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnPrevious.layer setCornerRadius:5.0f];
    
    [self.tableViewGArticle reloadData];

}

-(void)setActivityIndicator{
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce color:[UIColor whiteColor]];
    
    [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    
    [self.view addSubview:_spinner];
    [_spinner hidesWhenStopped];
}

#pragma mark - Hit Api
-(void)hitAPI{
    
    [self setActivityIndicator];

    [_spinner startAnimating];
    
    [ModalGold getGContent : urlGoldContent :@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSArray *response_success) {
        
       //NSLog(@"%@",response_success);
       
        arrayGArticle = [NSMutableArray arrayWithArray:response_success.mutableCopy];
        [self.tableViewGArticle reloadData];
        
        [_spinner stopAnimating];
        
    } :^(NSString *response_error) {
        
        
    }];
    
}

#pragma mark - Actions
- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionBtnPrevious:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionFbBtn:(id)sender {
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
    
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"content"]) {
        
        GContentViewController *vc = segue.destinationViewController;
        vc.titleArticle = selectedTitle;
        [vc sendUrl:sender];
    }
}

-(void)sendData:(NSArray *)arrayData{
    
    ModalGold *data = [ModalGold new];
    arrayGArticle  = [[NSMutableArray alloc] init];
    
    for (data in arrayData) {
        
        if ([data.mediaType isEqualToString:@"docx"]) {
            
            [arrayGArticle addObject:data];
        }
    }
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arrayGArticle count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ModalGold *data = [arrayGArticle objectAtIndex:indexPath.row];
    GoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goldCell" forIndexPath:indexPath];
    
    NSString *uppercase = [data.title uppercaseString];
    
    [cell.lblTitle setHidden:YES];
    [cell.lblDesc setText:[NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1,uppercase]];
    
    [cell.imgArticle setImage:[UIImage imageNamed:[arrayImages objectAtIndex:(indexPath.row)%17]]];
//    [cell.imgArticle setImageWithURL:[NSURL URLWithString:data.imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ModalGold *data = [arrayGArticle objectAtIndex:indexPath.row];
    selectedTitle = data.title;
    [self performSegueWithIdentifier:@"content" sender:data.mediaUrl];
}

@end
