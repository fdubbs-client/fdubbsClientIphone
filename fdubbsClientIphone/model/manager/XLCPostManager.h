//
//  XLCPostManager.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XLCPostManager : NSObject

+ (XLCPostManager *) sharedXLCPostManager;

- (NSArray *)doLoadTop10Posts;

@end
