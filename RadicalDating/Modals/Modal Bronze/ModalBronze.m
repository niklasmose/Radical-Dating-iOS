//
//  ModalBronze.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "ModalBronze.h"

@implementation ModalBronze


+(void)getPickUpText:(NSString *)urlStr :(void (^)(NSArray *))success :(void (^)(NSString *))failure{
    
    [iOSRequest getJSONRespone:urlStr :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue]==1) {
            success([self parseDictToArray:[response_success valueForKey:@"data"]]);
        }
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
    
}

-(id)initwithAttributes:(NSDictionary *)dict
{
    self.pickUpLine  = [dict valueForKey:@"content"];
    
    return self;
}
+(NSArray*)parseDictToArray:(NSArray*)arrData{
    
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in arrData){
        [arrFinal addObject:[[ModalBronze alloc]initwithAttributes:dict]];
    }
    return arrFinal;
}

@end
