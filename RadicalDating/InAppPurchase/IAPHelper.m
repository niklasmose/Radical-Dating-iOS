//
//  IAPHelper.m
//  Gyde
//
//  Created by CB Macmini_3 on 02/07/15.
//  Copyright (c) 2015 CB Macmini_3. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
NSString *const IAPHelperProductPurchaseNotification = @"IAPHelperProductPurchaseNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    NSString *currentProductId;
}
@end

@implementation IAPHelper {
    SKProductsRequest *productRequest;
    RequestProductCompletionHandler _completionHandler;
    NSSet *_productIdentifiers;
    NSMutableSet *_purchasedProductIdentifier;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers  {
    
    if (self == [super init]) {
        
        //storing product identifiers
        _productIdentifiers =  productIdentifiers;
        
        
        //check for previous purchased products
        _purchasedProductIdentifier = [NSMutableSet set];
        for (NSString *strPro_Identifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:strPro_Identifier];
            if (productPurchased) {
                [_purchasedProductIdentifier addObject:strPro_Identifier];
               //NSLog(@"Previously Purchased:%@",strPro_Identifier);
            }
            else {
               //NSLog(@"not puchased:%@",strPro_Identifier);
            }
        }
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    return self;
}

- (void)requestProductWithCompletionHandler:(RequestProductCompletionHandler)completionHandler {
    _completionHandler = [completionHandler copy];
    productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    productRequest.delegate = self;
    [productRequest start];
}

#pragma mark - skproductRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
   
   //NSLog(@"Loading list of products");
    productRequest = nil;
    
    NSArray *skProduct = response.products;
    for (SKProduct *sk_product in skProduct) {
       //NSLog(@"%@ %@ %0.2f",sk_product.productIdentifier,sk_product.localizedTitle,sk_product.price.floatValue);
    }
    _completionHandler (YES, skProduct);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    
    [alert showError:@"error" subTitle:@"Failed to load" closeButtonTitle:@"Ok" duration:2.0f];
    
//    [Utility alert:@"" msg:@"Failed to load products"];
   //NSLog(@"failed to load products");
    productRequest = nil;
    _completionHandler (NO, nil);
    _completionHandler = nil;
}

- (BOOL)product_purchased:(NSString *)product_Identifiers {
    return [_purchasedProductIdentifier containsObject:product_Identifiers];
}

#pragma mark - Buy Product
- (void)buy_Product:(SKProduct *)product {
    
   //NSLog(@"buying:%@",product.productIdentifier);
    
    currentProductId = product.productIdentifier;
    
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Payment Queue
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *payment_transation in transactions) {
        
        switch (payment_transation.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                [self completeTransection:payment_transation];
                break;
                
                case SKPaymentTransactionStateRestored:
                [self restoreTrasaction:payment_transation];
                break;
                
                case SKPaymentTransactionStateFailed:
                [self failedTransaction:payment_transation];
                break;
                
            default:
                [self.delegate delhideLoader];
                break;
        }
    }
}

- (void)completeTransection:(SKPaymentTransaction *)transaction {
    
    [self.delegate delhideLoader];

    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [self provideContentForProduct_Identifier:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    if ([currentProductId isEqualToString:silverPackageId]) {
     
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusSilver"];
        
        [self subscribeSilverPack:YES];
    }
    
    else if ([currentProductId isEqualToString:goldPackageId]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusGold"];
        
        [self subscribeGoldPack:YES];
    }
}

-(void)subscribeSilverPack:(BOOL)open{
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    [alert showWaiting:nil subTitle:@"connecting to server..." closeButtonTitle:@"OK" duration:50.0f];
    
    [ModalSubscribe addPackageSubscription:urlAddSilverSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
        
        [alert hideView];
        [self.delegate delhideLoader];
        if (open==YES) {
            [self.customDelegate silverTapped];
        }
        
    } :^(NSString *response_error) {
        
        [self subscribeSilverPack:open];
    }];

}

-(void)subscribeGoldPack:(BOOL)open{
    
    SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
    [alert showWaiting:nil subTitle:@"connecting to server..." closeButtonTitle:@"OK" duration:50.0f];
    
    [ModalSubscribe addPackageSubscription:urlAddGoldSubs parameter:@{@"device_id":[[NSUserDefaults standardUserDefaults] stringForKey:deviceID]} :^(NSDictionary *response_success) {
        
        [alert hideView];
        [self.delegate delhideLoader];
        if (open==YES) {
            
            [self.customDelegate goldTapped];
        }
        
    } :^(NSString *response_error) {
        
        [self subscribeGoldPack:open];
    }];

}

- (void)restoreTrasaction:(SKPaymentTransaction *)transection {
   
   //NSLog(@"restored Transaction");
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    [self provideContentForProduct_Identifier:transection.originalTransaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transection];
    
    [self.delegate delhideLoader];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
   //NSLog(@"Failed Trasaction");
    [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        
        [self.delegate delhideLoader];
        
        SCLAlertView *alert = [[SCLAlertView alloc]initWithNewWindow];
        [alert showError:@"error" subTitle:@"Your Purchase failed.Please try again" closeButtonTitle:@"Ok" duration:2.0f];
        
       //NSLog(@"Trasaction error :%@",transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProduct_Identifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifier addObject:productIdentifier];
    
    if ([productIdentifier isEqualToString:silverPackageId]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusSilver"];
        
        [self subscribeSilverPack:NO];
    }
    
    if ([productIdentifier isEqualToString:goldPackageId]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"statusGold"];
        
        [self subscribeGoldPack:NO];
    }

//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchaseNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


@end
