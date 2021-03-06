//
//  XLCPostMetaData.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCPostMetaData.h"

static RKObjectMapping *objectMapping = nil;

@implementation XLCPostMetaData

+ (RKObjectMapping *) objectMapping
{
    if (objectMapping != nil) {
        return objectMapping;
    }
    
    objectMapping = [RKObjectMapping mappingForClass:[XLCPostMetaData class]];
    [objectMapping addAttributeMappingsFromDictionary:@{
                                                              @"post_id" : @"postId",
                                                              @"title" : @"title",
                                                              @"owner" : @"owner",
                                                              @"nick" : @"nick",
                                                              @"date" : @"date",
                                                              @"board" : @"board"
                                                              }];
    
    return objectMapping;
}


- (id) init;
{
    self = [super init];
    
    if(self){

    }
    
    return self;
}

- (XLCPostMetaData *) withPostId:(NSString *)postId
{
    _postId = postId;
    return self;
}

- (XLCPostMetaData *) withTitle:(NSString *)title;
{
    _title = title;
    return self;
}

- (XLCPostMetaData *) withOwner:(NSString *)owner
{
    _owner = owner;
    return self;
}

- (XLCPostMetaData *) withNick:(NSString *)nick
{
    _nick = nick;
    return self;
}

- (XLCPostMetaData *) withDate:(NSString *)date
{
    _date = date;
    return self;
}

- (XLCPostMetaData *) withBoard:(NSString *)board
{
    _board = board;
    return self;
}

- (XLCPostMetaData *) withBoardId:(NSString *)boardId
{
    _boardId = boardId;
    return self;
}


@end
