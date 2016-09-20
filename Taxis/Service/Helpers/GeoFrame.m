//
//  GeoFrame.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "GeoFrame.h"

@implementation GeoFrame


+ (instancetype)shared {
    
    __strong static id shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

@end
