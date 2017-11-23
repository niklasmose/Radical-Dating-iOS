
//  MainMenuViewController.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.


#import "MainMenuViewController.h"

@interface MainMenuViewController (){
    
    NSString *selectedPackageId;
    alertView *popUPView;
    SCLAlertView *SAlert;
}

@end

@implementation MainMenuViewController

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self checkPushNoti:[[NSUserDefaults standardUserDefaults]valueForKey:@"PushNoti"]];
    [self hitAPI];
    
//    NSString *string =  [[UIDevice currentDevice].identifierForVendor UUIDString];
//
//    NSString *deviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceId"];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRecieved:) name:@"ActivePush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRecieved:) name:@"InactivePush" object:nil];

}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    [popUPView setFrame:self.view.frame];
    if ([_spinner isAnimating]) {
       
        [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height*3/4, 25, 25)];
//        [_spinner setFrame:_viewActivity.frame];
//        [_spinner setCenter:_viewActivity.center];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    application.applicationIconBadgeNumber = 0;

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - alert
-(void)showAlertView:(NSString*)title with:(NSString*)msg{
    
     popUPView = [[[NSBundle mainBundle] loadNibNamed:@"alertView" owner:self options:nil] lastObject];
    
//    [popUPView.lblPrice setText:msg];
    [popUPView.lblTitle setText:title];

    [popUPView setFrame:self.view.bounds];

    [self.view addSubview:popUPView];
    [popUPView setDelegate:self];
}

-(void)showAlert:(NSString*)msg{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([msg isEqualToString:@"Your response has been recorded!"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)showAlert:(NSString*)title with:(NSString*)msg alertType:(int)type{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self manageNotification:type];
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertController addAction:OKAction];
    [alertController addAction:CancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - API
-(void)hitAPI{
    
    if (![self internetWorking]) {
        
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showWarning:nil subTitle:@"Internet is not working" closeButtonTitle:@"Ok" duration:5.0f];
    }
    
    [_imgSplash setHidden:NO];
    [self setActivityIndicator];
    
    NSString *deviceId = [[NSUserDefaults standardUserDefaults]stringForKey:deviceID];
    
    [ModalSubscribe registerId:urlRegister :@{@"device_id":deviceId} :^(NSDictionary *response_success) {
        
       //NSLog(@"%@",response_success);
                
        [_imgSplash setHidden:YES];
        [_spinner stopAnimating];

        if ([[response_success valueForKey:@"success"]integerValue]==1) {
            
            NSDictionary *price = [NSDictionary dictionaryWithDictionary:[response_success valueForKey:@"price"]];
            
            _priceBronze = (NSString*)[price valueForKey:@"bronze"];
            _priceSilver = (NSString*)[price valueForKey:@"silver"];
            _priceGold = (NSString*)[price valueForKey:@"gold"];
            
            NSDictionary *status = [NSDictionary dictionaryWithDictionary:[response_success valueForKey:@"subs"]];
            
            _statusBronze = (NSString*)[status valueForKey:@"bronze"];
            _statusSilver = (NSString*)[status valueForKey:@"silver"];
            _statusGold = (NSString*)[status valueForKey:@"gold"];
            
            if ([_statusSilver integerValue]==1) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusSilver"];
            }
            
            if ([_statusGold integerValue]==1) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusGold"];
            }

            [self updateAPIIfRequired];
        }

    } :^(NSString *response_error) {
        
//        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
//        [alert showError:nil subTitle:response_error closeButtonTitle:@"Ok" duration:5.0f];
      
        [_imgSplash setHidden:YES];
        [_spinner stopAnimating];

       //NSLog(@"%@",response_error);

    }];
}

-(void)hitApiNewsLetter{
    
    [popUPView removeFromSuperview];
    
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:deviceID];
    NSString *email = [NSString stringWithString:popUPView.txtEmail.text];
    NSString *name = [NSString stringWithString:popUPView.txtName.text];
    
    [ModalSubscribe sendDetails:urlSubscribe :@{@"device_id":deviceId, @"email":email,@"name":name}:^(NSDictionary *response_success) {
        
        
    } :^(NSString *response_error) {
        
    }];
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


#pragma mark - Set UI
-(void)setUI{
    
    [_imgSplash setHidden:NO];
    [_viewActivity setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;

    UITapGestureRecognizer *tapOnBronze = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bronzeTapped)];
    UITapGestureRecognizer *tapOnSilver = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(silverTapped)];
    UITapGestureRecognizer *tapOnGold = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goldTapped)];

    [self.viewBronze addGestureRecognizer:tapOnBronze];
    [self.viewSilver addGestureRecognizer:tapOnSilver];
    [self.viewGold addGestureRecognizer:tapOnGold];
    
    [_viewGold setExclusiveTouch:YES];
    [_viewSilver setExclusiveTouch:YES];
    [_viewBronze setExclusiveTouch:YES];
}

-(void)setActivityIndicator{
    
    [_imgSplash setHidden:NO];
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce color:[UIColor whiteColor]];
    
    [_spinner setFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height*3/4, 25, 25)];
   
    
    [self.view addSubview:_spinner];
    [_spinner hidesWhenStopped];
    
    [_spinner startAnimating];

}


#pragma mark - Package Tapped

-(void)bronzeTapped{
    
    [self performSegueWithIdentifier:@"bronze" sender:nil];
    
}

-(void)silverTapped{
    
    selectedPackageId = silverPackageId;
    
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"statusSilver"]integerValue]==1) {
        
        [self performSegueWithIdentifier:@"silver" sender:@"Silver"];
    }
    else{
        
        NSString *msg = [NSString stringWithFormat:@"Price : $%@",_priceSilver];
        
        [self showAlertView:@"SILVER SUBSCRIPTION" with:msg];
    }
}

-(void)goldTapped{
    
    selectedPackageId = goldPackageId;
    
    if ([[[NSUserDefaults standardUserDefaults]stringForKey:@"statusGold"]integerValue]==1) {
        
        [self performSegueWithIdentifier:@"gold" sender:@"Gold"];
    }
    else{
        
        NSString *msg = [NSString stringWithFormat:@"Price : $%@",_priceGold];
        
        [self showAlertView:@"GOLD SUBSCRIPTION" with:msg];
    }
}

#pragma mark - Actions
- (IBAction)actionBtnBronze:(id)sender {
    [self bronzeTapped];
}

- (IBAction)actionBtnSilver:(id)sender {
    [self silverTapped];
}

- (IBAction)actionBtnGold:(id)sender {
    [self goldTapped];
}

- (IBAction)actionBtnFb:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
    }
}

#pragma mark -
#pragma mark - Action Buy

-(void)actionBtnBuy{
    
    if ([self checkValidation]) {
    
        [self hitApiNewsLetter];
    }
    
    [popUPView removeFromSuperview];
    
    SAlert = [[SCLAlertView alloc]initWithNewWindow];
    [SAlert setCustomViewColor:[UIColor colorWithRed:230.0/255 green:0 blue:40.0/255 alpha:1.0f]];
    [SAlert showWaiting:nil subTitle:@"Connecting..." closeButtonTitle:@"Ok" duration:50.0f];
    
    [self fetchAndBuy];

}

-(void)actionBtnRestore{
    
    [popUPView removeFromSuperview];
    
//    SAlert = [[SCLAlertView alloc]initWithNewWindow];
//    [SAlert setCustomViewColor:[UIColor colorWithRed:230.0/255 green:0 blue:40.0/255 alpha:1.0f]];
//    [SAlert showWaiting:nil subTitle:@"Connecting..." closeButtonTitle:@"Ok" duration:2.0f];

//    [[RDIAPHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
    
//       //NSLog(@"%@",products);
        

//        for (SKProduct *product in products) {
//            
//            if ([product.productIdentifier isEqualToString:selectedPackageId]) {
//                
//                [[RDIAPHelper sharedInstance] setDelegate:self];
//                [[RDIAPHelper sharedInstance] setCustomDelegate:self];
//                
////                BOOL status = [[RDIAPHelper sharedInstance] product_purchased:selectedPackageId];
//            
                [[RDIAPHelper sharedInstance] restoreCompletedTransactions];
//                
//                if (status) {
//                    
//                    if ([selectedPackageId isEqualToString:silverPackageId]) {
//                        
//                        [self subscribeSilverPack];
//                    }
//                    else{
//                        
//                        [self subscribeGoldPack];
//                    }
//                }
//                else{
//                    
//                    [self showAlert:@"Item not perchased previously"];
//                }
//            }
//            
//        }
//    }];

}

-(void)subscribeSilverPack{
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    [alert showWaiting:nil subTitle:@"connecting to server..." closeButtonTitle:@"OK" duration:50.0f];
    
    [ModalSubscribe addPackageSubscription:urlAddSilverSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
        
        [alert hideView];
        [self silverTapped];
        
    } :^(NSString *response_error) {
        
        [self subscribeSilverPack];
    }];
    
}

-(void)subscribeGoldPack{
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    [alert showWaiting:nil subTitle:@"connecting to server..." closeButtonTitle:@"OK" duration:50.0f];
    
    [ModalSubscribe addPackageSubscription:urlAddGoldSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
        
        [alert hideView];
        [self goldTapped];
    } :^(NSString *response_error) {
        
        [self subscribeGoldPack];
    }];
    
}

-(void)actionBtnFacebook{
    
    NSArray *permissionsArray = @[@"public_profile",@"email"];

    _login = [[FBSDKLoginManager alloc]init];
    [_login logOut];
    
    [_login logInWithReadPermissions: permissionsArray
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         
         if (error) {
            //NSLog(@"Process error");
             
             SAlert = [[SCLAlertView alloc]initWithNewWindow];
             [SAlert showError:nil subTitle:@"Facebook authentication failed, please try again." closeButtonTitle:@"Ok" duration:5.0f];
         } else if (result.isCancelled) {
            //NSLog(@"Cancelled");
             
         } else {
            //NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                         //NSLog(@"fetched user:%@", result);
                         //NSLog(@"%@",result[@"email"]);
                          
                          [popUPView.txtEmail setText:result[@"email"]];
                          [popUPView.txtName setText:result[@"name"]];
                         //NSLog(@"%@",[result valueForKey:@"name"]);
                          
                      }
                  }];
             }
         }
     }];
}

#pragma mark - Notification Handler
-(void)pushRecieved:(NSNotification *)notification{
    
   //NSLog(@"%@",notification.userInfo);
    NSDictionary *dictNoti = [NSDictionary dictionaryWithDictionary:[notification.userInfo valueForKey:@"aps"]];
    
    int type  =(int)[dictNoti[@"data"][@"type"]integerValue];
    
//    if ([notification.name isEqualToString:@"InactivePush"]) {
//        
//    [self manageNotification:type];
//        
//    }
//    
//    else
//    {
    switch (type) {
        
        case 1:
            [self showAlert:@"Tips & Tricks" with:dictNoti[@"alert"]alertType:1];
            break;
        
        case 2:
            [self showAlert:@"Rate our App" with:dictNoti[@"alert"]alertType:2];
            break;
        
        case 3:
            [self showAlert:@"Radical Dating" with:dictNoti[@"alert"]alertType:3];
            break;
            
        default:
            break;
    }
//    }
}

-(void)checkPushNoti:(NSDictionary*)dict{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PushNoti"];
    
    if (dict) {
    
        NSDictionary *dictNoti = [NSDictionary dictionaryWithDictionary:[dict valueForKey:@"aps"]];
        
        int type  =(int)[dictNoti[@"data"][@"type"]integerValue];

        [self manageNotification:type];
    }
}
-(void)manageNotification:(int)type{
    
    switch (type) {
            
        case 1:
            
            if(![[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]){
                
                [self performSegueWithIdentifier:@"newsletter" sender:nil];
            }
            break;
            
        case 2:
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/radical-dating/id1108895664?ls=1&mt=8"]];
            break;
            
        case 3:
            
            if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageId]]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbFanpageUrl]];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Purchase
-(void)fetchAndBuy{
    
    [[RDIAPHelper sharedInstance] requestProductWithCompletionHandler:^(BOOL success, NSArray *products) {
        
       //NSLog(@"%@",products);
                
        for (SKProduct *product in products) {
            
            if ([product.productIdentifier isEqualToString:selectedPackageId]) {
                
                [[RDIAPHelper sharedInstance] setDelegate:self];
                [[RDIAPHelper sharedInstance] setCustomDelegate:self];
                [[RDIAPHelper sharedInstance] buy_Product:product];
            }
        }
    }];
}

#pragma mark - Validations
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)checkValidation{
    
    NSString *email = [NSString stringWithString:[popUPView.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//    NSString *name = [popUPView.txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (![self NSStringIsValidEmail:email]) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark - updateAPI if Required
-(void)updateAPIIfRequired{
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"statsusSilver"]!=nil) {
        
        BOOL statusSilver = [[[NSUserDefaults standardUserDefaults] stringForKey:@"statusSilver"]isEqualToString:_statusSilver];

        if (!statusSilver) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusSilver"];
            
            [ModalSubscribe addPackageSubscription:urlAddSilverSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
                
            } :^(NSString *response_error) {}];
        }

    }
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"statsusSilver"]!=nil) {
        
        BOOL statusGold = [[[NSUserDefaults standardUserDefaults] stringForKey:@"statusGold"]isEqualToString:_statusGold];
        
        if (!statusGold) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusGold"];
            
            [ModalSubscribe addPackageSubscription:urlAddGoldSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
                
            } :^(NSString *response_error) {}];
        }
    }
}

#pragma mark - Loader delegates
-(void)delShowLoader{
    
    
    [SAlert showWaiting:nil subTitle:@"Buying..." closeButtonTitle:@"Ok" duration:50.0f];

}

-(void)delhideLoader{
    
    [SAlert hideView];
}

@end
