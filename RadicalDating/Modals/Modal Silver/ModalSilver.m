//
//  ModalSilver.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "ModalSilver.h"

@implementation ModalSilver


+(void)getSContent:(NSString *)urlStr :(NSDictionary *)param :(void (^)(NSArray *,NSDictionary*))success :(void (^)(NSString *))failure{
   
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue]==1) {
            success([self parseDictToArray:[response_success valueForKey:@"data"]],response_success);
        }
        else if (response_success==nil){
            failure(@"No data available");
        }
        else{
            failure([response_success valueForKey:@"msg"]);
        }
        
    } :^(NSError *response_error) {
              
        failure(response_error.localizedDescription);
    }];
}

-(id)initwithAttributes:(NSDictionary *)dict
{
    self.id  = [dict valueForKey:@"id"];
    self.mediaType  = [dict valueForKey:@"media_type"];
    self.mediaUrl  = [dict valueForKey:@"media_url"];
    self.title  = [dict valueForKey:@"title"];
    self.content  = [dict valueForKey:@"content"];
    
    return self;
}

+(NSArray*)parseDictToArray:(NSArray*)arrData{
    
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in arrData){
        [arrFinal addObject:[[ModalSilver alloc]initwithAttributes:dict]];
    }
    return arrFinal;
}
@end
