//
//  ServiceManager.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "ServiceManager.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation ServiceManager

+ (instancetype)sharedManager{
    static id shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = self.new;
    });
    return shared;
}

- (void)getLastLocationsForDriversInArea:(GeoFrame*)geoArea completionHandler:(ServiceManagerCompletionHandler)completionHandler {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString* URLString = [NSString stringWithFormat:@"%@?sw=%@,%@&ne=%@,%@",kServiceLocations, geoArea.SWlatitude, geoArea.SWlongitude, geoArea.NElatitude, geoArea.NElongitude];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            completionHandler(nil,error);
            
        } else {
            
            NSError *err = nil;
            NSArray *taxis = [MTLJSONAdapter modelsOfClass:Taxi.class fromJSONArray:responseObject error:&err];
            completionHandler(taxis, nil);
            
        }
        
    }];
    
    [dataTask resume];
    
}

- (void)registerUserWithName:(NSString*)name completionHandler:(ServiceManagerCompletionHandler)completionHandler {
    
    if (name.length == 0) {
        NSError *error = [NSError errorWithDomain:@"com.rihurla.Taxis" code:200 userInfo:@{@"Error reason": @"Parameter Name is missing"}];
        completionHandler(nil, error);
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@",kServiceURL,kServiceUser];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:@{@"name":name} error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            completionHandler(nil,error);
            
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            NSString *location = [dictionary valueForKey:@"Location"];
            NSArray *arrayWithLocation = [location componentsSeparatedByString:@"/"];

            User* newUser = [[User alloc]init];
            newUser.registrationID = @([arrayWithLocation.lastObject intValue]);
            newUser.name = name;
            newUser.latitude = [NSNumber numberWithInt:0];
            newUser.longitude = [NSNumber numberWithInt:0];
            
            completionHandler(newUser, nil);
            
        }
        
    }];
    
    [dataTask resume];

}

- (void)requestRideForUser:(User*)user completionHandler:(ServiceManagerCompletionHandler)completionHandler {
    
    if (!user.registrationID || !user.latitude || !user.longitude) {
        NSError *error = [NSError errorWithDomain:@"com.rihurla.Taxis" code:200 userInfo:@{@"Error reason": @"Missing parameters"}];
        completionHandler(nil, error);
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSDictionary* parameters = @{@"user_id":user.registrationID,
                                 @"user_latittude":user.latitude,
                                 @"user_longitude":user.longitude};
    
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@",kServiceURL,kServiceRide];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {

            completionHandler(responseObject,error);
            
        } else {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            NSDictionary *dictionary = [httpResponse allHeaderFields];
            NSString *location = [dictionary valueForKey:@"Location"];
            NSArray *arrayWithLocation = [location componentsSeparatedByString:@"/"];
            
            Ride* newRide = [[Ride alloc]init];
            newRide.rideId = @([arrayWithLocation.lastObject intValue]);
            
            completionHandler(newRide, nil);
            
        }
        
    }];
    
    [dataTask resume];
}

@end
