//
//  ModalBronze.h
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iOSRequest.h"

@interface ModalBronze : NSObject

@property(strong,nonatomic)NSString* pickUpLine;

+(void)getPickUpText : (NSString*)urlStr : (void(^) (NSArray* response_success))success : (void(^) (NSString* response_error))failure;

@end
