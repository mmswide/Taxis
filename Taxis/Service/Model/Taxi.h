//
//  Taxi.h
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Taxi : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;
@property(nonatomic, strong) NSNumber *driverId;
@property(nonatomic, strong) NSNumber *isDriverAvailable;

@end
