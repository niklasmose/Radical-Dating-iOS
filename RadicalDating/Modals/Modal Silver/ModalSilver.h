//
//  ModalSilver.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"

@interface ModalSilver : NSObject

#pragma mark - Properties

@property(strong,nonatomic)NSString *id;
@property(strong,nonatomic)NSString *mediaType;
@property(strong,nonatomic)NSString *mediaUrl;
@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSArray *content;


+(void)getSContent : (NSString*)urlStr : (NSDictionary*)param : (void(^) (NSArray* response_success,NSDictionary* res))success : (void(^) (NSString* response_error))failure;


@end
