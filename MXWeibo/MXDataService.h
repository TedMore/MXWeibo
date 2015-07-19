//
//  MXDataService.h
//  MXWeibo
//
//  Created by TedChen on 7/16/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestFinishBlock)(id result);

@interface MXDataService : NSObject

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                     completeBlock:(RequestFinishBlock)block;

@end
