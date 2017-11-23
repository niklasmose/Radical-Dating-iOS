//
//  AppDelegate.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 07/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "constants.h"
#import "Modals/Modal Subscribe/ModalSubscribe.h"
#import "iOSRequest.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark -Application methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
    if([launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey] forKey:@"PushNoti"];
    }
    
    NSString *string =  [NSString stringWithString:[[UIDevice currentDevice].identifierForVendor UUIDString]];
    
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:deviceID];
    
    [NSThread sleepForTimeInterval:2];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self.window makeKeyAndVisible];
    
    [self showsubscriptionPopupIfNeeded];
    
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken{
    
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString:@" " withString: @""];
    
    application.applicationIconBadgeNumber = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"RDDeviceToken"];
    
    NSString *devideId = [[NSUserDefaults standardUserDefaults] stringForKey:deviceID];
    
    [[ModalSubscribe new] setDeviceToken:@{@"device_id":devideId,@"device_token":deviceToken} :^(NSDictionary *response_success) {} :^(NSString *response_error) {}];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
   //NSLog(@"Failed to get token, error: %@", error);
}

-(void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InactivePush" object:nil userInfo:userInfo];
    }
    else if([UIApplication sharedApplication].applicationState==UIApplicationStateActive){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActivePush" object:nil userInfo:userInfo];
    }
}

- (void)showsubscriptionPopupIfNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isSubscribed = [defaults boolForKey:@"IsSubscribed"];
    
    if (!isSubscribed) {
        static NSString* openCountKey = @"AppOpenCount";
        NSInteger count = 0;
        if ([defaults integerForKey:openCountKey]) {
            count = [defaults integerForKey:openCountKey];
            count++;
            
            if (count >= 3) {
                count = 0;
                [self showsubscriptionPopup];
            }
        }
        else count++;
        
        [defaults setInteger:count forKey:openCountKey];
        [defaults synchronize];
    }
}

- (void)showsubscriptionPopup {
    
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:nil message:@"Subscribe and Get Your Free Ebook Bonus" preferredStyle:UIAlertControllerStyleAlert];
    [alerController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter your email here";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString*email = [[alerController textFields][0] text];
        
        if ([self isValidEmail:email]) {
            [self subscribeNewletterWithEmail:email];
        }
        else [self showEmailInvaidAlert];
    }];
    
    [alerController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alerController addAction:cancelAction];
    [self.window.rootViewController presentViewController:alerController animated:YES completion:nil];
}

- (void)subscribeNewletterWithEmail:(NSString*)email{
    
    NSString *devideId = [[NSUserDefaults standardUserDefaults] stringForKey:deviceID];
    
    [iOSRequest postData:urlNewsletterSubscription
                        :@{@"email" : email,
                           @"device_id" : devideId}
                        :^(NSDictionary *response_success) {
                            if ([[response_success valueForKey:@"success"] integerValue]==1) {
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                [defaults setBool:YES forKey:@"IsSubscribed"];
                                [defaults synchronize];
                                
                                // Get started
                                SCLAlertView *alert = [[SCLAlertView alloc] init];
                                
                                [alert showSuccess:self.window.rootViewController title:@"Congratulations!!" subTitle:@"You have now Subscribed to our Free Ebook Bonus" closeButtonTitle:@"OK" duration:0.0f];

                            }
                        } :^(NSError *response_error) {
                        }];
}

- (void)showEmailInvaidAlert {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Invalid email!!" message:@"Please enter a valid email." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showsubscriptionPopup];
    }];
    [alerController addAction:confirmAction];
    [self.window.rootViewController presentViewController:alerController animated:YES completion:nil];
}

#pragma mark - Validations
-(BOOL)isValidEmail:(NSString *)checkString {
    checkString = [NSString stringWithString:[checkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Open Url

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"]) {
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
