//
//  Taxi.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "Taxi.h"

@implementation Taxi

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"latitude": @"latitude",
             @"longitude": @"longitude",
             @"driverId": @"driverId",
             @"isDriverAvailable": @"driverAvailable"};
}

@end
