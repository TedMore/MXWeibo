//
//  CommentModel.m
//  MXWeibo
//
//  Created by TedChen on 7/11/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

//注：此model的属性名称 与 新浪微博接口返回的字段名称 相同，就不用使用映射方法 attributeMapDictionary

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    NSDictionary *weiboDic = [dataDic objectForKey:@"status"];
    
    WeiboModel *weibo = [[[WeiboModel alloc] initWithDataDic:weiboDic] autorelease];
    UserModel *user = [[[UserModel alloc] initWithDataDic:userDic] autorelease];
    
    self.weibo = weibo;
    self.user = user;
    
}

@end
