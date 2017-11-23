//
//  IAPHelper.h
//  Gyde
//
//  Created by CB Macmini_3 on 02/07/15.
//  Copyright (c) 2015 CB Macmini_3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
//#import "Utility.h"
//#import "UIView+Toast.h"
#import <SCLAlertView.h>

#import "constants.h"
#import "ModalSubscribe.h"

@protocol customDelegate

@optional
-(void)silverTapped;
-(void)goldTapped;
@end

@protocol LoaderDelgate
@optional
-(void)delShowLoader;
-(void)delhideLoader;

@end

UIKIT_EXTERN NSString *const IAPHelperProductPurchaseNotification;

typedef void (^RequestProductCompletionHandler) (BOOL success, NSArray *products);


@interface IAPHelper : NSObject


@property(nonatomic, assign)id <LoaderDelgate>delegate;
@property (nonatomic,assign) id <customDelegate> customDelegate;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductWithCompletionHandler:(RequestProductCompletionHandler)completionHandler;

- (void)buy_Product:(SKProduct *)product;
- (BOOL)product_purchased:(NSString *)product_Identifiers;
- (void)restoreCompletedTransactions;


@end
