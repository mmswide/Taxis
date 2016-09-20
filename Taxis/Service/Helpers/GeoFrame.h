//
//  GeoFrame.h
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GeoFrame : MTLModel

@property(nonatomic, strong) NSNumber *SWlatitude;
@property(nonatomic, strong) NSNumber *SWlongitude;
@property(nonatomic, strong) NSNumber *NElatitude;
@property(nonatomic, strong) NSNumber *NElongitude;

+ (instancetype)shared;

@end
