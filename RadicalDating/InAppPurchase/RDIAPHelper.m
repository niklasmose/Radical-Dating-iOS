//
//  RDIAPHelper.m
//  Radical Dating
//
//  Created by Rajmani on 05/05/16.
//  Copyright (c) 2015 CB Macmini_3. All rights reserved.
//

#import "RDIAPHelper.h"

@implementation RDIAPHelper

+ (RDIAPHelper *)sharedInstance {
    
    static dispatch_once_t once;
    static RDIAPHelper *sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifier = [NSSet setWithObjects:@"com.codebrew.RadicalDating.GoldPackage", @"com.codebrew.RadicalDating.SilverPackage", nil];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifier];
    });
    return sharedInstance;
}

@end
