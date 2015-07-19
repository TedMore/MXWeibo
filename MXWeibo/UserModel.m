//
//  UserModel.m
//  MXWeibo
//
//  Created by TedChen on 7/10/15.
//  Copyright (c) 2015 LEON. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
                             @"idstr":@"idstr",
                             @"screen_name":@"screen_name",
                             @"name":@"name",
                             @"desc":@"description",
                             @"location":@"location",
                             @"url":@"url",
                             @"profile_image_url":@"profile_image_url",
                             @"avatar_large":@"avatar_large",
                             @"gender":@"gender",
                             @"followers_count":@"followers_count",
                             @"friends_count":@"friends_count",
                             @"statuses_count":@"statuses_count",
                             @"favourites_count":@"favourites_count",
                             @"verified":@"verified"
                             };
    
    return mapAtt;
}

@end
