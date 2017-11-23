//
//  ModalSubscribe.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 13/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "ModalSubscribe.h"

@implementation ModalSubscribe

+(void)addPackageSubscription:(NSString *)urlStr parameter:(NSDictionary *)param :(void (^)(NSDictionary *))success :(void (^)(NSString *))failure{
    
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
        
        success(response_success);
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
}

+(void)sendDetails : (NSString*)urlStr : (NSDictionary*)param : (void(^) (NSDictionary* response_success))success : (void(^) (NSString* response_error))failure{
    
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue]==1) {
            
            success(response_success);
        }
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
}

+(void)registerId:(NSString *)urlStr :(NSDictionary *)param :(void (^)(NSDictionary *))success :(void (^)(NSString *))failure{
    
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
        
        success(response_success);
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
    
}
                    
-(void)setDeviceToken:(NSDictionary *)param :(void (^)(NSDictionary *))success :(void (^)(NSString *))failure{
    
    [iOSRequest postData:urlSetDeviceToken :param :^(NSDictionary *response_success) {
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
}

@end
