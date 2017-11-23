//
//  ModalGold.m
//  RadicalDating
//
//  Created by Rajmani Kushwaha on 08/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "ModalGold.h"

@implementation ModalGold


+(void)getGContent:(NSString *)urlStr :(NSDictionary *)param :(void (^)(NSArray *))success :(void (^)(NSString *))failure{
    
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
                
        if ([[response_success valueForKey:@"success"] integerValue]==1) {
            
            success([self parseDictToArray:[response_success valueForKey:@"data"]]);
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
    self.content = [dict valueForKey:@"content"];
    self.imageUrl = [dict valueForKey:@"image"];

    return self;
}

+(NSArray*)parseDictToArray:(NSArray*)arrData{
    
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in arrData){
        
        if([[dict valueForKey:@"media_type"] isEqualToString:@"docx"])
        
            [arrFinal addObject:[[ModalGold alloc]initwithAttributes:dict]];
    }
    
    return arrFinal;
}

+(void)getAudio:(NSString *)urlStr :(NSDictionary *)param :(void (^)(NSArray *,NSDictionary*))success :(void (^)(NSString *))failure{
    
    [iOSRequest postData:urlStr :param :^(NSDictionary *response_success) {
        
        if ([[response_success valueForKey:@"success"] integerValue]==1) {
            
            success([self parseDictToAudio:[response_success valueForKey:@"data"]],response_success);
        }
        
        
    } :^(NSError *response_error) {
        
        failure(response_error.localizedDescription);
    }];
 
}

+(NSArray*)parseDictToAudio:(NSArray*)arrData{
    
    NSMutableArray *arrFinal = [[NSMutableArray alloc]init];
    for(NSDictionary *dict in arrData){
        
//        if([[dict valueForKey:@"media_type"] isEqualToString:@"mp3"])
        
            [arrFinal addObject:[[ModalGold alloc]initwithAttributes:dict]];
    }
    
    return arrFinal;
}


@end
