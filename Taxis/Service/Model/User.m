//
//  User.m
//  Taxis
//
//  Created by Ricardo Hurla on 20/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"registrationID": @"registrationID",
             @"name": @"name",
             @"latitude": @"latitude",
             @"longitude": @"longitude"};
}

@end
