//
//  XLCLoginResponse.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-15.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginResponse.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCLoginResponse

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCLoginResponse class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                          @"result_code" : @"resultCode",
                                                          @"error_message" : @"errorMessage",
                                                          @"auth_code" : @"authCode"
                                                          }];
    
    return objectMapping;
}

@end
