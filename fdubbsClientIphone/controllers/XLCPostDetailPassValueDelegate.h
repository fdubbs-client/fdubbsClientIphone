//
//  XLCPostDetailPassValueDelegate.h
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.

#import <Foundation/Foundation.h>

@protocol XLCPostDetailPassValueDelegate <NSObject>

-(void) passValueWithBoardName:(NSString *) boardName postGid:(NSString *)gid;


@end
