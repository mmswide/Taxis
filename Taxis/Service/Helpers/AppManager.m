//
//  AppManager.m
//  Taxis
//
//  Created by Ricardo Hurla on 20/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "AppManager.h"
#import "AFNetworking.h"

@implementation AppManager

+ (instancetype)sharedManager {
    
    __strong static id shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (void)startConnectionMonitoring {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        [self.delegate didUpdateConnectionStatus:@(status)];

    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)stopConnectionMonitoring {
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
}

- (void)persistUser:(User *)user completionHandler:(CompletionHandler)completionHandler {

    NSError *error = nil;
    NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:user error:&error];

    NSUserDefaults* defauts = [NSUserDefaults standardUserDefaults];
    [defauts setObject:JSONDictionary forKey:@"registered_user"];
    [defauts synchronize];
    completionHandler(@(YES),error);
    
}

- (void)getRegisteredUserWithcompletionHandler:(CompletionHandler)completionHandler{
    
    NSUserDefaults* defauts = [NSUserDefaults standardUserDefaults];
    if ([defauts objectForKey:@"registered_user"]) {
        
        NSError *error = nil;
        NSDictionary *JSONDictionary = [defauts objectForKey:@"registered_user"];

        User *retrievedUser = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:JSONDictionary error:&error];
        completionHandler(retrievedUser,error);
        
    } else {
        
        completionHandler(nil,nil);
        
    }
    
}


@end
