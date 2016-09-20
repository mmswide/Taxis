//
//  User.h
//  Taxis
//
//  Created by Ricardo Hurla on 20/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSNumber *registrationID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *latitude;
@property(nonatomic, strong) NSNumber *longitude;

@end
