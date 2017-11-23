//
//  ModalSubscribe.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 13/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"
#import "constants.h"

@interface ModalSubscribe : NSObject



+(void)sendDetails : (NSString*)urlStr : (NSDictionary*)param : (void(^) (NSDictionary* response_success))success : (void(^) (NSString* response_error))failure;

+(void)registerId : (NSString*)urlStr : (NSDictionary*)param : (void(^) (NSDictionary* response_success))success : (void(^) (NSString* response_error))failure;

-(void)setDeviceToken:(NSDictionary*)param : (void(^) (NSDictionary* response_success)) success : (void(^) (NSString* response_error))failure;

+(void)addPackageSubscription:(NSString*)urlStr parameter:(NSDictionary*)param : (void(^)(NSDictionary* response_success))success : (void(^)(NSString* response_error))failure;
@end
