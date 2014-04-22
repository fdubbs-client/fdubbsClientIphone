//
//  XLCPostManager.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XLCPostDetail;

@interface XLCPostManager : NSObject

+ (XLCPostManager *) sharedXLCPostManager;

- (void) doLoadTop10PostsWithSuccessBlock:(void (^)(NSArray *))success
                                failBlock:(void (^)(NSError *))failure;

- (void) doLoadPostDetailWithBoardName:(NSString *)boardName postId:(NSString *)postId
                          SuccessBlock:(void (^)(XLCPostDetail *))success
                             failBlock:(void (^)(NSError *))failure;
@end
