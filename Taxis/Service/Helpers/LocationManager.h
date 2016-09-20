//
//  LocationManager.h
//  Taxis
//
//  Created by Ricardo Hurla on 8/20/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate;

typedef void(^LocationCompletionHandler)(id result, NSError * error);

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, assign) id<LocationManagerDelegate> delegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

+ (instancetype)sharedManager;

//Provides a address based on the coordinated from a location
- (void)getAddressFromLocation:(CLLocation *)location completionHandler:(LocationCompletionHandler)completionHandler;
//Provides the location based on the written address
- (void)getLocationFromAddress:(NSString *)address completionHandler:(LocationCompletionHandler)completionHandler;
//Provides the user location
- (void)getUserLocationWithCompletionHandler:(LocationCompletionHandler)completionHandler;

@end

@protocol LocationManagerDelegate <NSObject>

@optional
//Updates the user location
- (void)didUpdateToLocation:(CLLocation *)newLocation fromOldLocation:(CLLocation *)oldLocation;

@end