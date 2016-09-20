//
//  LocationManager.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/20/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>

@implementation LocationManager

+ (instancetype)sharedManager {
    
    __strong static id shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)getAddressFromLocation:(CLLocation *)location completionHandler:(LocationCompletionHandler)completionHandler {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        if (error) {
            
            completionHandler(nil, error);
            
        } else {
            
            CLPlacemark *placemark = [placemarks lastObject];
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            NSString *addressString = [lines componentsJoinedByString:@",\n"];
            
            completionHandler(addressString, nil);
        }
    }];
    
}

- (void)getLocationFromAddress:(NSString *)address completionHandler:(LocationCompletionHandler)completionHandler {

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            completionHandler(nil, error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            completionHandler(placemark, nil);
  
        }
    }];
    
}

- (void)getUserLocationWithCompletionHandler:(LocationCompletionHandler)completionHandler {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    if (self.locationManager.location) {
        self.location = self.locationManager.location;
        completionHandler(self.location, nil);
    }
    
}

#pragma mark - CCLocation Manager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.delegate didUpdateToLocation:newLocation fromOldLocation:oldLocation];
    
}

@end
