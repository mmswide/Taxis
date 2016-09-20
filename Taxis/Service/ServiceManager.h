//
//  ServiceManager.h
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoFrame.h"
#import "Ride.h"
#import "User.h"
#import "Taxi.h"

typedef void(^ServiceManagerCompletionHandler)(id result, NSError * error);

@interface ServiceManager : NSObject

+ (instancetype)sharedManager;

//Request the drivers nearby
- (void)getLastLocationsForDriversInArea:(GeoFrame*)geoArea completionHandler:(ServiceManagerCompletionHandler)completionHandler;
//Register a user
- (void)registerUserWithName:(NSString*)name completionHandler:(ServiceManagerCompletionHandler)completionHandler;
//Request ride for a user
- (void)requestRideForUser:(User*)user completionHandler:(ServiceManagerCompletionHandler)completionHandler;

@end
