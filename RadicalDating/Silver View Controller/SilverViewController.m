
//  SilverViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import "SilverViewController.h"

@interface SilverViewController (){
    
    NSMutableArray *arraySContent,*arrayImages;
    NSString *selectedTitle;
    NSURL *URL;
    UIDocumentInteractionController *documentInteractionController;
    NSInteger tableViewHeight;
}

@end

@implementation SilverViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self hitAPI];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        
        tableViewHeight = self.tableViewS.frame.size.height/4;
    }
    else{
        tableViewHeight = self.tableViewS.frame.size.height/2;
    }


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
    if ([_spinner isAnimating]) {
        
        [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        tableViewHeight = self.tableViewS.frame.size.height/4;
        [_tableViewS reloadData];
    }
    else {
        
        tableViewHeight = self.tableViewS.frame.size.height/2;
        [_tableViewS reloadData];
    }
}
#pragma mark - Basic setup
-(void)setUI{
        
    arraySContent = [[NSMutableArray alloc] init];
    arrayImages = [NSMutableArray arrayWithObjects:@"img_being_social",@"img_First_Date_Tips",@"img_Style_Body",@"img_ebooks", nil];

    [self.btnHome.layer setBorderWidth:0.5f];
    [self.btnHome.layer setBorderColor:[UIColor lightTextColor].CGColor];
    [self.btnHome.layer setCornerRadius:5.0f];
    
    [self setActivityIndicator];
}

-(void)setActivityIndicator{
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce color:[UIColor whiteColor]];
    
    [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2-10, 25, 25)];
    
    [self.view addSubview:_spinner];
    [_spinner hidesWhenStopped];
    [_spinner stopAnimating];
}

#pragma mark - API
-(void)hitAPI{
    
    if (![self internetWorking]) {
//        _textResponse.text=@"Internet is not working!";
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:nil subTitle:@"Internet is not working" closeButtonTitle:@"Ok" duration:5.0f];
    }
    else{
//        _textResponse.text=[NSString stringWithFormat:@"hitting api : %@",urlSilverContent];

      [_spinner startAnimating];
        NSString *devideID = [[NSUserDefaults standardUserDefaults] stringForKey:deviceID];
        [ModalSilver getSContent:urlSilverContent :@{@"device_id":devideID} :^(NSArray *response_success,NSDictionary* totalReponse) {
            arraySContent = response_success.mutableCopy;
            [_spinner stopAnimating];            
            [_tableViewS reloadData];
            [_tableViewS setHidden:NO];
//            _textResponse.text=[NSString stringWithFormat:@"%@",totalReponse];

        } :^(NSString *response_error) {
//            _textResponse.text=[NSString stringWithFormat:@" error : %@",response_error];
            [_spinner stopAnimating];
            
            [self showAlert:response_error];
            
        }];
    }
}


-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [self hitAPI];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    [alertController addAction:OKAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Reachability

-(BOOL)internetWorking{
    
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        
        return NO;
    }
    else{
        
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"article"]){
        
        SContentViewController *vc = segue.destinationViewController;
        vc.titleArticle = selectedTitle;
        [vc sendData:sender];
    }
    
    else if ([segue.identifier isEqualToString:@"eBook"]){
        
        eBookViewController *vc = segue.destinationViewController;
        vc.url = [NSString stringWithFormat:@"%@",sender];
    }
}

#pragma mark - eBook Tapped
-(void)eBookTapped{
    
   //NSLog(@"eBook tapped!");
    ModalSilver *data;
    
    for (data in arraySContent) {
      
        if ([data.mediaType isEqualToString:@"pdf"] && [data.mediaUrl containsString:@"http"]) {
            
            [self performSegueWithIdentifier:@"eBook" sender:data.mediaUrl];
        }
    }
}

#pragma mark - Action Button
- (IBAction)actionBtnHome:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
}

#pragma mark - TableView Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableViewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [arraySContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SilverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sArticle" forIndexPath:indexPath];
    ModalSilver *data = [arraySContent objectAtIndex:indexPath.row];
    
    [cell.imgCell setImage:[UIImage imageNamed:[arrayImages objectAtIndex:indexPath.row]]];
    [cell.lblDesc setText:data.title];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==arraySContent.count-1) {
        
        [self eBookTapped];
    }
    else{
        
        ModalSilver *data = [arraySContent objectAtIndex:indexPath.row];
        selectedTitle = data.title;
        [self performSegueWithIdentifier:@"article" sender:data.content];

    }
}

@end
